#!/usr/bin/env python3
"""
Play a .wbg bagpipe tune file, mimicking windbag.perl logic.
Usage: python3 refactored_play_wbg.py [tunefile.wbg] [melody_multiplier] [gracenote_ms]

This is a cleaned-up rewrite of play_wbg.py.  The logic is identical but the
code is split into three focused functions (parse → render → play) instead of
one monolithic play_tune(), unused imports are removed, constants are promoted
to module level, and argument parsing uses argparse for proper --help support.

Requires macOS (uses afplay for audio output).

.wbg format recap:
  - Tokens are separated by commas, spaces or line breaks.
  - Tokens alternate: note_letter, duration_value, note_letter, duration_value, ...
  - Embellishment names (dbe, tar, hvthrd, gg, ...) stand for their gracenotes and
    are expanded first, as in windbag2.perl and the web edition.
  - Note letters: g a b c d e f G A  (low g through high A on the chanter)
  - Duration values are integer multiples of a base unit, e.g.
      0  = grace note (played for a fixed short time, not a musical duration)
      24 = 8th note, 48 = quarter note, 96 = half note, 192 = whole note
  - Numeric tokens > 20000 (e.g. 30000), and z, are rest/silence markers.
"""

import argparse
import re
import subprocess
import sys
import tempfile
import wave
from pathlib import Path

import numpy as np

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

# PCM sample rate used for both synthesis and the WAV header.
# Defined once here so make_beep and render_audio always agree.
SAMPLE_RATE = 44100

# The Great Highland Bagpipe chanter has nine notes: g a b c d e f G A.
# These are their approximate frequencies in Hz (sourced from chanter.txt).
# Low-g is ~409 Hz; high-A is ~921 Hz.
_CHANTER_NOTES = 'g a b c d e f G A'.split()
_CHANTER_FREQS = [409, 460, 518, 576, 622, 691, 768, 829, 921]

# Build the note→frequency lookup from the two lists above.
# Using zip() keeps the two lists in lockstep and makes it obvious they must
# stay the same length — unlike the original which indexed CHANTER manually.
NOTE_MAP: dict[str, int] = dict(zip(_CHANTER_NOTES, _CHANTER_FREQS))

# Embellishment names, as in windbag2.perl and play.html's ORNAMENTS, in the same
# order: each is replaced by its gracenotes before the tokens are split, and
# longer names must go before the shorter ones they contain.
ORNAMENTS: list[tuple[str, str]] = [
    ('tar',    'g 0 d 0 g 0 e 0'),   # taorluath
    ('hvthrd', 'g 0 d 0 g 0 c 0'),   # heavy throw
    ('abr',    'a 0 g 0 a 0 g 0'),
    ('dbb',    'G 0 b 0 d 0'),       # doubling on B
    ('dbc',    'G 0 c 0 d 0'),
    ('dbe',    'G 0 e 0 f 0'),
    ('hdbf',   'f 0 G 0'),           # half doubling on F; before dbf, which it contains
    ('dbf',    'G 0 f 0 G 0'),
    ('dbhg',   'G 0 f 0'),           # doubling on high G
    ('dbha',   'A 0 G 0'),           # doubling on high A
    ('grp',    'g 0 d 0 g 0'),       # grip
    ('brl',    'g 0 a 0 g 0'),       # birl
    ('strlg',  'g 0'),               # strike on G
    ('strla',  'a 0'),               # strike on A
    ('gstrd',  'G 0 d 0 g 0'),       # G strike on D
    ('bg',     'b 0'),               # single-note gracenote shortcuts
    ('cg',     'c 0'),
    ('eg',     'e 0'),
    ('dg',     'd 0'),
    ('fg',     'f 0'),
    ('gg',     'G 0'),               # high G gracenote
    ('tg',     'A 0'),               # high A ("top") gracenote
]


def expand_ornaments(text: str) -> str:
    """Replace every embellishment name with its gracenotes."""
    for name, expansion in ORNAMENTS:
        text = text.replace(name, expansion)
    return text


# ---------------------------------------------------------------------------
# Audio generation
# ---------------------------------------------------------------------------

def make_beep(freq: int, duration_ms: float, sample_rate: int = SAMPLE_RATE) -> np.ndarray:
    """
    Synthesise a single note as a mono int16 PCM array.

    Parameters
    ----------
    freq        : pitch in Hz.  Pass 0 to get silence (a rest).
    duration_ms : note length in milliseconds.  Returns an empty array if <= 0.
    sample_rate : samples per second; must match the WAV file header.

    How it works
    ------------
    1. Convert duration_ms to a sample count n_samples.
    2. For freq > 0, generate a pure sine wave using np.arange instead of
       np.linspace — this avoids allocating a separate float64 time array that
       would immediately be discarded after the multiply.
    3. Apply a 5 ms linear fade-in and fade-out to prevent audible clicks
       where consecutive notes meet (a click is an instantaneous amplitude jump).
    4. Scale to 60% of the int16 maximum (32767) to leave headroom and avoid
       clipping when many notes are concatenated.
    """
    n_samples = int(sample_rate * duration_ms / 1000.0)

    if n_samples <= 0:
        return np.array([], dtype=np.int16)

    if freq == 0:
        # Rest: return silence without bothering with the sine calculation
        return np.zeros(n_samples, dtype=np.int16)

    # angular_freq is the phase increment per sample: 2π·freq / sample_rate.
    # Multiplying by np.arange(n_samples) gives the instantaneous phase at
    # each sample index, which is the argument to sin().
    angular_freq = 2.0 * np.pi * freq / sample_rate
    wave_data = np.sin(np.arange(n_samples) * angular_freq)

    # Fade length: 5 ms of samples, capped at a quarter of the note so that
    # very short grace notes (~20 ms) don't get a fade longer than their body.
    fade = min(int(sample_rate * 0.005), n_samples // 4)
    if fade > 0:
        wave_data[:fade]  *= np.linspace(0, 1, fade)   # ramp up
        wave_data[-fade:] *= np.linspace(1, 0, fade)   # ramp down

    return (wave_data * 32767 * 0.6).astype(np.int16)


# ---------------------------------------------------------------------------
# Parsing
# ---------------------------------------------------------------------------

def parse_wbg(path: Path) -> list[tuple[int, int]]:
    """
    Read a .wbg tune file and return a list of (frequency_hz, duration_units) pairs.

    Embellishment names are expanded first. Commas, spaces and newlines are
    interchangeable delimiters; re.split(r'[,\\s]+') handles all three in one
    pass and naturally skips empty fields.

    Token resolution rules (matching windbag.perl):
      - A recognised note letter → looked up in NOTE_MAP to get Hz.
      - An integer ≤ 20000       → used as-is (raw Hz value).
      - An integer > 20000       → treated as a rest (freq = 0).
      - Anything else            → the pair is skipped entirely.

    If the second token of a pair can't be parsed as an integer (the stream is
    mis-aligned), we advance by one token and retry rather than skipping two,
    so the parser can re-sync on the next valid pair.
    """
    raw = expand_ornaments(path.read_text(errors='replace'))

    # Split on any run of commas/whitespace; filter out empty fragments
    tokens = [t for t in re.split(r'[,\s]+', raw) if t]

    song: list[tuple[int, int]] = []
    i = 0
    while i < len(tokens) - 1:
        note_token = tokens[i].strip()
        dur_token  = tokens[i + 1].strip()

        # Second token must be a duration integer
        try:
            dur = int(dur_token)
        except ValueError:
            i += 1   # re-sync by advancing one token and retrying
            continue

        # Resolve note letter → frequency
        if note_token in NOTE_MAP:
            freq = NOTE_MAP[note_token]
        elif note_token == 'z':
            freq = 0   # rest
        else:
            try:
                freq = int(note_token)
                if freq > 20000:
                    freq = 0   # out-of-range numeric → silence/rest
            except ValueError:
                i += 2   # completely unrecognised pair; skip both tokens
                continue

        song.append((freq, dur))
        i += 2

    return song


# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------

def render_audio(
    song: list[tuple[int, int]],
    melody: int = 7,
    gracenote_ms: int = 20,
    sample_rate: int = SAMPLE_RATE,
) -> np.ndarray:
    """
    Convert a parsed song into a flat int16 PCM array ready for WAV output.

    Parameters
    ----------
    song         : list of (freq_hz, duration_units) pairs from parse_wbg().
    melody       : melody multiplier — duration_units × melody = milliseconds.
                   Larger values play slower.  ~7 gives a good march tempo.
    gracenote_ms : how long each grace note plays in milliseconds (~20 ms).
    sample_rate  : must match the value used by make_beep and the WAV header.

    Grace-note timing (mirroring windbag.perl exactly)
    ---------------------------------------------------
    Grace notes have duration_units == 0 in the file.  They are ornamental
    notes that precede a melody note and must not add time to the tune.
    The implementation:
      1. Plays each grace note for exactly gracenote_ms milliseconds.
      2. Counts consecutive grace notes in grace_count.
      3. When the following melody note is reached, subtracts
         (grace_count × gracenote_ms) from its duration so the total elapsed
         time is unchanged.

    Memory
    ------
    Rather than growing a Python list of arrays and then letting np.concatenate
    make one final O(N) copy, we collect the clips first, compute the exact
    total sample count, allocate a single output buffer, and fill it in one
    pass — halving peak memory usage for long tunes.
    """
    clips: list[np.ndarray] = []
    grace_count = 0   # number of grace notes preceding the next melody note

    for freq, note_length in song:
        if note_length == 0:
            # Grace note: fixed short duration regardless of melody speed.
            # Increment grace_count so the following melody note will be
            # shortened by the same amount, keeping total duration constant.
            clips.append(make_beep(freq, gracenote_ms, sample_rate))
            grace_count += 1
        else:
            # Melody note: scale by the multiplier, then repay the time
            # already consumed by any preceding grace notes.
            dur_ms = max(0, (note_length * melody) - (grace_count * gracenote_ms))
            grace_count = 0
            # make_beep handles freq==0 (rest) internally by returning zeros,
            # so no special-case branch is needed here.
            clips.append(make_beep(freq, dur_ms, sample_rate))

    if not clips:
        return np.array([], dtype=np.int16)

    # Pre-allocate one contiguous output buffer and copy each clip into it.
    # This avoids the repeated intermediate allocations that np.concatenate
    # would produce when called on a long list of small arrays.
    total = sum(len(c) for c in clips)
    out = np.empty(total, dtype=np.int16)
    offset = 0
    for clip in clips:
        out[offset:offset + len(clip)] = clip
        offset += len(clip)
    return out


# ---------------------------------------------------------------------------
# Playback
# ---------------------------------------------------------------------------

def play_audio(samples: np.ndarray, sample_rate: int = SAMPLE_RATE) -> None:
    """
    Write a PCM array to a temporary WAV file and play it via afplay (macOS).

    The temp file is created inside the NamedTemporaryFile context and written
    to in the same open call (wave.open accepts a file-like object), avoiding
    the double-open that the original code had (create → close → reopen).

    The file is deleted in a finally block so it is always cleaned up even if
    afplay raises an exception.  check=True on subprocess.run means a non-zero
    afplay exit code surfaces as a CalledProcessError rather than silently
    succeeding.
    """
    with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as tmp:
        tmp_path = Path(tmp.name)
        # Write the WAV header and PCM data into the still-open temp file
        with wave.open(tmp, 'w') as wf:
            wf.setnchannels(1)      # mono
            wf.setsampwidth(2)      # 16-bit samples (2 bytes each)
            wf.setframerate(sample_rate)
            wf.writeframes(samples.tobytes())

    try:
        subprocess.run(['afplay', str(tmp_path)], check=True)
    except FileNotFoundError:
        # afplay is macOS-only; give a clear message instead of a raw traceback
        raise RuntimeError('afplay not found — this script requires macOS') from None
    finally:
        # Always remove the temp file, even if playback fails
        tmp_path.unlink(missing_ok=True)


# ---------------------------------------------------------------------------
# CLI entry point
# ---------------------------------------------------------------------------

def main() -> None:
    """Parse command-line arguments and run the full parse → render → play pipeline."""
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        'tunefile', nargs='?',
        default=str(Path(__file__).resolve().parent.parent / 'tunes' / 'band_set_garry_owen.wbg'),
        help='Path to a .wbg tune file (default: tunes/band_set_garry_owen.wbg)',
    )
    parser.add_argument(
        'melody', nargs='?', type=int, default=7,
        help='Melody multiplier: duration_units × this = ms.  Larger = slower (default: 7)',
    )
    parser.add_argument(
        'gracenote', nargs='?', type=int, default=20,
        help='Grace note duration in milliseconds (default: 20)',
    )
    args = parser.parse_args()

    tune_path = Path(args.tunefile)
    if not tune_path.exists():
        print(f'error: file not found: {tune_path}', file=sys.stderr)
        sys.exit(1)

    print(f'Playing {tune_path.name} ...')
    song  = parse_wbg(tune_path)
    audio = render_audio(song, melody=args.melody, gracenote_ms=args.gracenote)
    play_audio(audio)


if __name__ == '__main__':
    main()
