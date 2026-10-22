# Win(d)Bag

**[Read the writeup](https://gernreich.github.io/windbag/)** ·
**[Play the tunes](https://gernreich.github.io/windbag/play.html)**

A Great Highland bagpipe tune player for Windows 3.1, written in Visual Basic 3
between 1995 and 2000. The first version, now lost, was written in BASIC on an
IBM PCjr. Tunes are typed as plain text in the `.wbg` format and
played on the PC speaker, with the melody and gracenote speeds set separately.
The web edition plays the same files in a browser.

**Whose work this is.** Win(d)Bag, the `.wbg` format, the practice-chanter
tuning window, the Perl players and the colouring of the Holbein woodcut are
Michael Carnright's. The web edition and the Python players are later ports. The
tunes are traditional or his own, and their `.wbg` transcriptions are his.

## Contents

| Path | What |
|---|---|
| `index.html` | the writeup |
| `play.html` | the web edition; `play.html?test` runs its parser tests |
| `vb3/` | Visual Basic 3 source of version 0.2 (16 September 2000): forms, modules, project, button images, format notes, original READMEs |
| `perl/` | `windbag.perl`, `windbag2.perl` (adds embellishment names) and helpers |
| `python/` | terminal, Tk and uilleann players for macOS (comma format only) |
| `tunes/` | 34 tunes: traditional tunes, band sets, exercises and two demos |
| `images/le-fol.png` | Holbein's *Le Fol*, as coloured for the original main window |
| `bundle_tunes.py` | builds every `.wbg` in `tunes/` into `play.html` |

## Adding a tune

Put the `.wbg` file in `tunes/` and run

```
python3 bundle_tunes.py
```

or just drop the file on the web edition.

The Visual Basic runtime and the third-party controls the program needs
(`VBRUN300.DLL`, `CMDIALOG.VBX`, `THREED.VBX`, `WINSOUND.DLL`) are not included.
