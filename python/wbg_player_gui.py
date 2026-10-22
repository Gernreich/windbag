#!/usr/bin/env python3
"""
macOS GUI player for .wbg bagpipe tune files.
Uses only tkinter which ships with Python on macOS.
"""

import subprocess
import sys
import threading
from pathlib import Path
import tkinter as tk
from tkinter import ttk, messagebox

SCRIPT_DIR = Path(__file__).parent.resolve()
WBG_DIR    = SCRIPT_DIR.parent / "tunes"
PLAYER     = SCRIPT_DIR / "refactored_play_wbg.py"


def get_tunes() -> list[Path]:
    return sorted(WBG_DIR.glob("*.wbg"))


class WbgPlayer(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("WinBag Player 🎵")
        self.resizable(True, True)
        self.minsize(500, 400)
        self.configure(bg="#1e1e2e")

        self.tunes       = get_tunes()
        self.playing     = False
        self.proc        = None

        self._build_ui()
        self._populate_list()

    # ------------------------------------------------------------------
    # UI construction
    # ------------------------------------------------------------------

    def _build_ui(self):
        BG      = "#1e1e2e"
        FG      = "#cdd6f4"
        ACCENT  = "#89b4fa"
        FIELD   = "#313244"
        BTN_PLY = "#a6e3a1"
        BTN_STP = "#f38ba8"
        SEL_BG  = "#45475a"

        self.configure(bg=BG)
        style = ttk.Style(self)
        style.theme_use("clam")
        style.configure("Treeview",
                         background=FIELD, foreground=FG,
                         fieldbackground=FIELD, rowheight=22,
                         font=("Menlo", 12))
        style.configure("Treeview.Heading",
                         background=BG, foreground=ACCENT,
                         font=("Menlo", 11, "bold"))
        style.map("Treeview", background=[("selected", ACCENT)],
                              foreground=[("selected", BG)])
        style.configure("Vertical.TScrollbar", background=FIELD, troughcolor=BG)

        # ── Title ──────────────────────────────────────────────────────
        tk.Label(self, text="🎵  WinBag Player",
                 bg=BG, fg=ACCENT,
                 font=("Helvetica Neue", 18, "bold"),
                 pady=10).pack(fill="x", padx=20)

        # ── Parameters ────────────────────────────────────────────────
        param_frame = tk.Frame(self, bg=BG)
        param_frame.pack(fill="x", padx=20, pady=(0, 8))

        for col, (label, attr, default) in enumerate([
            ("Melody", "melody_var", "20"),
            ("Gracenote", "gracenote_var", "30"),
        ]):
            setattr(self, attr, tk.StringVar(value=default))
            var = getattr(self, attr)

            tk.Label(param_frame, text=label + ":", bg=BG, fg=FG,
                     font=("Helvetica Neue", 13)).grid(row=0, column=col*2,
                                                        padx=(0 if col else 0, 4),
                                                        sticky="e")
            tk.Entry(param_frame, textvariable=var, width=6,
                     bg=FIELD, fg=ACCENT, insertbackground=ACCENT,
                     relief="flat", font=("Menlo", 13),
                     highlightthickness=1,
                     highlightcolor=ACCENT,
                     highlightbackground=FIELD).grid(row=0, column=col*2+1,
                                                      padx=(0, 20), sticky="w")

        # ── Search box ────────────────────────────────────────────────
        search_frame = tk.Frame(self, bg=BG)
        search_frame.pack(fill="x", padx=20, pady=(0, 6))
        tk.Label(search_frame, text="Filter:", bg=BG, fg=FG,
                 font=("Helvetica Neue", 12)).pack(side="left", padx=(0, 6))
        self.search_var = tk.StringVar()
        self.search_var.trace_add("write", self._on_search)
        tk.Entry(search_frame, textvariable=self.search_var, width=30,
                 bg=FIELD, fg=FG, insertbackground=FG,
                 relief="flat", font=("Menlo", 12),
                 highlightthickness=1, highlightcolor=ACCENT,
                 highlightbackground=FIELD).pack(side="left")

        # ── Tune list ─────────────────────────────────────────────────
        list_frame = tk.Frame(self, bg=BG)
        list_frame.pack(fill="both", expand=True, padx=20, pady=(0, 8))

        self.tree = ttk.Treeview(list_frame, columns=("name",),
                                  show="headings", selectmode="browse")
        self.tree.heading("name", text="Tune")
        self.tree.column("name", anchor="w")
        self.tree.bind("<Double-1>", lambda e: self._play())
        self.tree.bind("<Return>",   lambda e: self._play())

        sb = ttk.Scrollbar(list_frame, orient="vertical",
                            command=self.tree.yview)
        self.tree.configure(yscrollcommand=sb.set)
        self.tree.pack(side="left", fill="both", expand=True)
        sb.pack(side="right", fill="y")

        # ── Buttons ───────────────────────────────────────────────────
        btn_frame = tk.Frame(self, bg=BG)
        btn_frame.pack(fill="x", padx=20, pady=(0, 12))

        self.play_btn = tk.Button(btn_frame, text="▶  Play",
                                   bg=BTN_PLY, fg="#1e1e2e",
                                   font=("Helvetica Neue", 13, "bold"),
                                   relief="flat", padx=20, pady=6,
                                   cursor="pointinghand",
                                   command=self._play)
        self.play_btn.pack(side="left", padx=(0, 10))

        self.stop_btn = tk.Button(btn_frame, text="■  Stop",
                                   bg=BTN_STP, fg="#1e1e2e",
                                   font=("Helvetica Neue", 13, "bold"),
                                   relief="flat", padx=20, pady=6,
                                   cursor="pointinghand",
                                   state="disabled",
                                   command=self._stop)
        self.stop_btn.pack(side="left")

        # ── Status bar ────────────────────────────────────────────────
        self.status_var = tk.StringVar(value="Select a tune and press Play")
        tk.Label(self, textvariable=self.status_var,
                 bg="#181825", fg=FG,
                 font=("Menlo", 11), anchor="w",
                 padx=12, pady=6).pack(fill="x", side="bottom")

    # ------------------------------------------------------------------
    # List management
    # ------------------------------------------------------------------

    def _populate_list(self, filter_str=""):
        self.tree.delete(*self.tree.get_children())
        for tune in self.tunes:
            if filter_str.lower() in tune.stem.lower():
                self.tree.insert("", "end", iid=str(tune), values=(tune.stem,))
        # Select first item
        children = self.tree.get_children()
        if children:
            self.tree.selection_set(children[0])
            self.tree.focus(children[0])

    def _on_search(self, *_):
        self._populate_list(self.search_var.get())

    # ------------------------------------------------------------------
    # Playback
    # ------------------------------------------------------------------

    def _play(self):
        sel = self.tree.selection()
        if not sel:
            messagebox.showwarning("No tune selected", "Please select a tune first.")
            return

        try:
            melody    = int(self.melody_var.get())
            gracenote = int(self.gracenote_var.get())
        except ValueError:
            messagebox.showerror("Bad values",
                                 "Melody and Gracenote must be integers.")
            return

        if self.playing:
            self._stop()

        tune = Path(sel[0])
        self.status_var.set(f"▶  Playing: {tune.stem}  "
                            f"(melody={melody}  gracenote={gracenote})")
        self.playing = True
        self.play_btn.config(state="disabled")
        self.stop_btn.config(state="normal")

        def run():
            self.proc = subprocess.Popen(
                [sys.executable, str(PLAYER), str(tune),
                 str(melody), str(gracenote)],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            )
            self.proc.wait()
            self.after(0, self._on_done, tune.stem)

        threading.Thread(target=run, daemon=True).start()

    def _stop(self):
        if self.proc and self.proc.poll() is None:
            self.proc.terminate()

    def _on_done(self, name):
        self.playing = False
        self.proc    = None
        self.play_btn.config(state="normal")
        self.stop_btn.config(state="disabled")
        self.status_var.set(f"✓  Done: {name}")


if __name__ == "__main__":
    if not WBG_DIR.exists():
        print(f"Error: wbg/ folder not found at {WBG_DIR}")
        sys.exit(1)
    app = WbgPlayer()
    app.mainloop()
