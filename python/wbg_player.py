#!/usr/bin/env python3
"""
Interactive terminal UI for playing .wbg bagpipe tune files.
Uses only the Python standard library (curses) — no extra packages needed.

Controls:
  Up/Down     navigate tune list
  PgUp/PgDn   jump 10 tunes
  Enter       play selected tune
  Tab         cycle between Melody / Gracenote fields to edit
  0-9         type a new value into the active field
  Backspace   delete last digit in active field
  Q           quit
"""

import curses
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent.resolve()
WBG_DIR    = SCRIPT_DIR / "wbg"
PLAYER     = SCRIPT_DIR / "refactored_play_wbg.py"


def get_tunes() -> list[Path]:
    return sorted(WBG_DIR.glob("*.wbg"))


def draw(stdscr, tunes, selected, fields, active_field, status):
    stdscr.erase()
    h, w = stdscr.getmaxyx()

    # Colour pairs
    curses.init_pair(1, curses.COLOR_CYAN,   curses.COLOR_BLACK)  # title
    curses.init_pair(2, curses.COLOR_YELLOW, curses.COLOR_BLACK)  # values
    curses.init_pair(3, curses.COLOR_BLACK,  curses.COLOR_WHITE)  # active field
    curses.init_pair(4, curses.COLOR_WHITE,  curses.COLOR_BLUE)   # selected row
    curses.init_pair(5, curses.COLOR_GREEN,  curses.COLOR_BLACK)  # status
    curses.init_pair(6, curses.COLOR_WHITE,  curses.COLOR_BLACK)  # normal

    # Title row
    title = " WinBag Player "
    stdscr.addstr(0, 2, title, curses.color_pair(1) | curses.A_BOLD)
    hint = "Up/Dn:navigate  Enter:play  Tab:edit fields  Q:quit"
    stdscr.addstr(0, len(title) + 4, hint[:w - len(title) - 6], curses.A_DIM)

    # Divider
    stdscr.addstr(1, 2, "─" * (w - 4), curses.A_DIM)

    # Parameter fields
    row = 2
    for i, (label, key) in enumerate([("Melody: ", "melody"), ("Gracenote: ", "gracenote")]):
        stdscr.addstr(row, 4, label, curses.A_BOLD)
        val_str = fields[key].ljust(5)
        if key == active_field:
            stdscr.addstr(row, 4 + len(label), val_str, curses.color_pair(3) | curses.A_BOLD)
        else:
            stdscr.addstr(row, 4 + len(label), val_str, curses.color_pair(2))
        row += 1

    # Divider
    stdscr.addstr(row, 2, "─" * (w - 4), curses.A_DIM)
    row += 1

    # Tune list
    list_top    = row
    list_height = h - list_top - 3
    start       = max(0, selected - list_height // 2)
    end         = min(len(tunes), start + list_height)

    for i in range(start, end):
        name = tunes[i].stem
        display = f" {name:<{w - 6}} "
        if i == selected:
            stdscr.addstr(list_top + (i - start), 2, display[:w-4],
                          curses.color_pair(4) | curses.A_BOLD)
        else:
            stdscr.addstr(list_top + (i - start), 2, display[:w-4],
                          curses.color_pair(6))

    # Status bar
    stdscr.addstr(h - 2, 2, "─" * (w - 4), curses.A_DIM)
    if status:
        stdscr.addstr(h - 1, 2, status[:w-4], curses.color_pair(5))
    else:
        stdscr.addstr(h - 1, 2, "Select a tune and press Enter to play"[:w-4], curses.A_DIM)

    stdscr.refresh()


def main(stdscr):
    curses.curs_set(0)
    curses.start_color()
    curses.use_default_colors()
    stdscr.keypad(True)

    tunes = get_tunes()
    if not tunes:
        stdscr.addstr(0, 0, f"No .wbg files found in {WBG_DIR}")
        stdscr.getch()
        return

    selected     = 0
    active_field = "melody"
    fields       = {"melody": "20", "gracenote": "30"}
    status       = ""

    draw(stdscr, tunes, selected, fields, active_field, status)

    while True:
        key = stdscr.getch()

        if key == curses.KEY_UP:
            selected = (selected - 1) % len(tunes)
            status   = ""
        elif key == curses.KEY_DOWN:
            selected = (selected + 1) % len(tunes)
            status   = ""
        elif key == curses.KEY_PPAGE:
            selected = max(0, selected - 10)
            status   = ""
        elif key == curses.KEY_NPAGE:
            selected = min(len(tunes) - 1, selected + 10)
            status   = ""
        elif key == ord('\t'):
            active_field = "gracenote" if active_field == "melody" else "melody"
        elif key in (curses.KEY_BACKSPACE, 127):
            fields[active_field] = fields[active_field][:-1]
        elif ord('0') <= key <= ord('9'):
            # Cap at 4 digits
            if len(fields[active_field]) < 4:
                fields[active_field] += chr(key)
        elif key in (curses.KEY_ENTER, ord('\n'), ord('\r')):
            tune = tunes[selected]
            try:
                melody    = int(fields["melody"]    or "0")
                gracenote = int(fields["gracenote"] or "0")
            except ValueError:
                status = "Invalid melody or gracenote value"
            else:
                status = f"Playing: {tune.stem}  (melody={melody} gracenote={gracenote})"
                draw(stdscr, tunes, selected, fields, active_field, status)
                subprocess.run(
                    [sys.executable, str(PLAYER), str(tune), str(melody), str(gracenote)],
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
                )
                status = f"Done: {tune.stem}"
        elif key in (ord('q'), ord('Q')):
            break

        draw(stdscr, tunes, selected, fields, active_field, status)


if __name__ == "__main__":
    curses.wrapper(main)
