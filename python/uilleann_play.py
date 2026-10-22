#!/usr/bin/env python3
"""
Play a .uwbg uilleann pipe tune file (chanter only, no drones).
Usage: python3 uilleann_play.py [tunefile.uwbg] [melody_multiplier]
       (a bare name such as "lament" is looked up in the repository's uwbg/ folder)
       python3 uilleann_play.py --scale   (play the full scale and exit)

Requires macOS (uses afplay for audio output).

--- Uilleann Chanter Scale (D, no cross-fingering) ---

Two full octaves plus the commonly used natural notes.
Lowercase = lower octave (D4–D5), uppercase = upper octave (E5–D6).

  Lower octave:
    d  = D4        = 293.66 Hz
    e  = E4        = 329.63 Hz
    f  = F#4       = 369.99 Hz
    n  = F natural4= 349.23 Hz
    g  = G4        = 392.00 Hz
    h  = G#4       = 415.30 Hz
    a  = A4        = 440.00 Hz
    b  = B4        = 493.88 Hz
    c  = C#5       = 554.37 Hz
    x  = C natural5= 523.25 Hz
    D  = D5        = 587.33 Hz  (bridge note, upper-case)

  Upper octave (overblown):
    E  = E5        = 659.25 Hz
    F  = F#5       = 739.99 Hz
    N  = F natural5= 698.46 Hz
    G  = G5        = 783.99 Hz
    H  = G#5       = 830.61 Hz
    A  = A5        = 880.00 Hz
    B  = B5        = 987.77 Hz
    C  = C#6       = 1108.73 Hz
    X  = C natural6= 1046.50 Hz
    R  = D6        = 1174.66 Hz  (high D, R avoids clash with d/D)

--- .uwbg file format ---

Comma/newline-delimited note,duration pairs:
  - Note letters use the table above (case-sensitive)
  - Duration units: 24=8th, 48=quarter, 96=half, 192=whole note
  - Numeric tokens > 20000 = rest/silence
  - No grace notes (uilleann ornaments are handled at the tune level)
"""

import argparse
import re
import subprocess
import sys
import tempfile
import wave
from pathlib import Path

import numpy as np

# The tunes that ship with the repository.
UWBG_DIR = Path(__file__).resolve().parent.parent / 'uwbg'

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

SAMPLE_RATE = 44100

# Full uilleann chanter note map including natural variants.
# Ordered chromatically within each octave for readability.
NOTE_MAP: dict[str, float] = {
    # --- Lower octave ---
    'd':  293.66,   # D4
    'e':  329.63,   # E4
    'n':  349.23,   # F natural 4
    'f':  369.99,   # F#4
    'g':  392.00,   # G4
    'h':  415.30,   # G#4
    'a':  440.00,   # A4
    'b':  493.88,   # B4
    'x':  523.25,   # C natural 5
    'c':  554.37,   # C#5
    'D':  587.33,   # D5  (bridge note)

    # --- Upper octave (overblown) ---
    'E':  659.25,   # E5
    'N':  698.46,   # F natural 5
    'F':  739.99,   # F#5
    'G':  783.99,   # G5
    'H':  830.61,   # G#5
    'A':  880.00,   # A5
    'B':  987.77,   # B5
    'X': 1046.50,   # C natural 6
    'C': 1108.73,   # C#6
    'R': 1174.66,   # D6  (high D)
}

# Scale order for --scale playback (low to high)
_SCALE_ORDER = ['d', 'e', 'n', 'f', 'g', 'h', 'a', 'b', 'x', 'c', 'D',
                'E', 'N', 'F', 'G', 'H', 'A', 'B', 'X', 'C', 'R']


# ---------------------------------------------------------------------------
# Audio generation
# ---------------------------------------------------------------------------

def make_beep(freq: float, duration_ms: float, sample_rate: int = SAMPLE_RATE) -> np.ndarray:
    """
    Synthesise a single note as a mono int16 PCM sine wave.

    freq = 0 produces silence (a rest).
    duration_ms <= 0 returns an empty array.

    A 5 ms linear fade-in/out suppresses clicks at note boundaries.
    Signal is scaled to 60% of int16 max to leave headroom.
    """
    n_samples = int(sample_rate * duration_ms / 1000.0)

    if n_samples <= 0:
        return np.array([], dtype=np.int16)
    if freq == 0:
        return np.zeros(n_samples, dtype=np.int16)

    angular_freq = 2.0 * np.pi * freq / sample_rate
    wave_data    = np.sin(np.arange(n_samples) * angular_freq)

    fade = min(int(sample_rate * 0.005), n_samples // 4)
    if fade > 0:
        wave_data[:fade]  *= np.linspace(0, 1, fade)
        wave_data[-fade:] *= np.linspace(1, 0, fade)

    return (wave_data * 32767 * 0.6).astype(np.int16)


# ---------------------------------------------------------------------------
# Parsing
# ---------------------------------------------------------------------------

def parse_uwbg(path: Path) -> list[tuple[float, int]]:
    """
    Parse a .uwbg file into a list of (frequency_hz, duration_units) pairs.

    Token rules:
      - Recognised note letter  → frequency from NOTE_MAP
      - Integer ≤ 20000         → used as raw Hz
      - Integer > 20000         → rest (freq = 0)
      - Anything else           → pair skipped
    """
    raw    = path.read_text()
    tokens = [t for t in re.split(r'[\n,]+', raw) if t.strip()]

    song: list[tuple[float, int]] = []
    i = 0
    while i < len(tokens) - 1:
        note_token = tokens[i].strip()
        dur_token  = tokens[i + 1].strip()

        try:
            dur = int(dur_token)
        except ValueError:
            i += 1   # re-sync
            continue

        if note_token in NOTE_MAP:
            freq = NOTE_MAP[note_token]
        else:
            try:
                freq = float(note_token)
                if freq > 20000:
                    freq = 0.0
            except ValueError:
                i += 2
                continue

        song.append((freq, dur))
        i += 2

    return song


# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------

def render_audio(
    song: list[tuple[float, int]],
    melody: int      = 7,
    sample_rate: int = SAMPLE_RATE,
) -> np.ndarray:
    """
    Convert a parsed song into a flat int16 PCM array.

    Each note's duration in ms = duration_units × melody.
    Audio is assembled into a single pre-allocated buffer to avoid
    O(N) intermediate copies from repeated np.concatenate calls.
    """
    clips: list[np.ndarray] = []

    for freq, note_length in song:
        dur_ms = note_length * melody
        clips.append(make_beep(freq, dur_ms, sample_rate))

    if not clips:
        return np.array([], dtype=np.int16)

    total  = sum(len(c) for c in clips)
    out    = np.empty(total, dtype=np.int16)
    offset = 0
    for clip in clips:
        out[offset:offset + len(clip)] = clip
        offset += len(clip)
    return out


# ---------------------------------------------------------------------------
# Playback
# ---------------------------------------------------------------------------

def play_audio(samples: np.ndarray, sample_rate: int = SAMPLE_RATE) -> None:
    """Write samples to a temp WAV and play via afplay (macOS)."""
    with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as tmp:
        tmp_path = Path(tmp.name)
        with wave.open(tmp, 'w') as wf:
            wf.setnchannels(1)
            wf.setsampwidth(2)
            wf.setframerate(sample_rate)
            wf.writeframes(samples.tobytes())
    try:
        subprocess.run(['afplay', str(tmp_path)], check=True)
    except FileNotFoundError:
        raise RuntimeError('afplay not found — this script requires macOS') from None
    finally:
        tmp_path.unlink(missing_ok=True)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        'tunefile', nargs='?', default=None,
        help='Path to a .uwbg tune file',
    )
    parser.add_argument(
        'melody', nargs='?', type=int, default=7,
        help='Melody multiplier: duration_units × this = ms  (default: 7)',
    )
    parser.add_argument(
        '--scale', action='store_true',
        help='Play the full chanter scale up and back down then exit',
    )
    args = parser.parse_args()

    if args.scale:
        print('Playing full uilleann chanter scale (D4 → D6 → D4) ...')
        up   = [(NOTE_MAP[n], 48) for n in _SCALE_ORDER]
        down = [(NOTE_MAP[n], 48) for n in reversed(_SCALE_ORDER)]
        audio = render_audio(up + down, melody=args.melody)
        play_audio(audio)
        return

    if args.tunefile is None:
        parser.print_help()
        print('\nTunes in', UWBG_DIR, ':')
        for t in sorted(UWBG_DIR.glob('*.uwbg')):
            print('  ' + t.stem)
        sys.exit(0)

    tune_path = Path(args.tunefile)
    if not tune_path.exists():
        named = UWBG_DIR / (tune_path.name if tune_path.suffix else tune_path.name + '.uwbg')
        if named.exists():
            tune_path = named
    if not tune_path.exists():
        print(f'error: file not found: {tune_path}', file=sys.stderr)
        sys.exit(1)

    print(f'Playing {tune_path.name} ...')
    song  = parse_uwbg(tune_path)
    audio = render_audio(song, melody=args.melody)
    play_audio(audio)


if __name__ == '__main__':
    main()
