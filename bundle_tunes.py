#!/usr/bin/env python3
"""Bundle every .wbg in tunes/ into the play.html beside this script.

Reads the current play.html, replaces the JSON between
<!-- BUNDLE_START --> and <!-- BUNDLE_END --> with a fresh {name: content}
object containing every tune.  Re-runnable: drop a new .wbg into the tunes
folder and run this again.
"""

import json
import os
import re
import sys

# Relative to this script, so the repository can live anywhere.
HERE = os.path.dirname(os.path.abspath(__file__))
TUNES_DIR = os.path.join(HERE, 'tunes')
HTML_PATH = os.path.join(HERE, 'play.html')

bundle = {}
for name in sorted(os.listdir(TUNES_DIR)):
    if not name.lower().endswith('.wbg'):
        continue
    path = os.path.join(TUNES_DIR, name)
    with open(path, 'r', encoding='utf-8', errors='replace') as f:
        bundle[name] = f.read()

# Compact JSON. ensure_ascii=False keeps any non-ASCII chars readable.
# Replace '</' with '<\/' so the JSON can't accidentally end the <script> tag.
bundle_json = json.dumps(bundle, ensure_ascii=False, separators=(',', ':'))
bundle_json = bundle_json.replace('</', '<\\/')

with open(HTML_PATH, 'r', encoding='utf-8') as f:
    html = f.read()

# Anchored to the bundle's own <script> tag: a comment in the page's code names
# both markers, and a bare marker pattern matched there first, pasting every
# tune into the comment as well.
pattern = re.compile(r'(<script type="application/json" id="tune-bundle">'
                     r'<!-- BUNDLE_START -->)[\s\S]*?(<!-- BUNDLE_END -->)')
found = len(pattern.findall(html))
if found != 1:
    sys.exit(f'ERROR: expected one tune-bundle block in the HTML, found {found}')

new_html = pattern.sub(lambda m: m.group(1) + bundle_json + m.group(2), html)

with open(HTML_PATH, 'w', encoding='utf-8') as f:
    f.write(new_html)

old_size = len(html)
new_size = len(new_html)
print(f'Embedded {len(bundle)} tunes')
print(f'HTML size: {old_size:,} -> {new_size:,} bytes ({new_size/1024:.0f} KB)')
