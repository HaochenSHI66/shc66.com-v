#!/usr/bin/env bash
# Smoke test for index.html. Usage: scripts/smoke.sh [--online]
# --online also curls every external URL (slower, needs network).
set -u
cd "$(dirname "$0")/.."
FAIL=0
say() { echo "[smoke] $*"; }
fail() { echo "[smoke] FAIL: $*"; FAIL=1; }

# 1. Banned patterns in visible copy
grep -q "—\|–" index.html && fail "em/en-dash found"
grep -q "·" index.html && fail "middle-dot separator found"
grep -q "BirdCLEF++" index.html && fail "wrong competition name BirdCLEF++"

# 2. Required anchors and strings
for id in about research projects skills contact main; do
  grep -q "id=\"$id\"" index.html || fail "missing anchor id=$id"
done
grep -q "<title>SHI Haochen" index.html || fail "title changed unexpectedly"
grep -q "263 of 4,094\|263rd of 4,094" index.html || fail "Kaggle rank drifted from certificate"

# 3. Local asset references all exist
grep -o 'href="assets/[^"]*"\|src="assets/[^"]*"' index.html | sed 's/^[a-z]*="//; s/"$//' | sort -u | while read -r f; do
  [ -f "$f" ] || echo "[smoke] FAIL: missing asset $f"
done | tee /tmp/smoke_assets.$$
grep -q FAIL /tmp/smoke_assets.$$ && FAIL=1; rm -f /tmp/smoke_assets.$$

# 4. HTML structure
python3 - <<'EOF' || FAIL=1
from html.parser import HTMLParser
import sys
src = open('index.html').read()
class Check(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.ids, self.headings, self.stack, self.issues = [], [], [], []
    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if 'id' in a:
            if a['id'] in self.ids: self.issues.append(f"duplicate id {a['id']}")
            self.ids.append(a['id'])
        if tag in ('h1','h2','h3','h4'): self.headings.append(int(tag[1]))
        if tag == 'img' and not a.get('alt', None) and a.get('alt') != '': self.issues.append(f"img missing alt: {a.get('src')}")
        if tag == 'a' and a.get('target') == '_blank' and 'noopener' not in (a.get('rel') or ''):
            self.issues.append(f"_blank without noopener: {a.get('href')}")
        if tag not in ('br','img','meta','link','input','hr','source'): self.stack.append(tag)
    def handle_endtag(self, tag):
        if self.stack and self.stack[-1] == tag: self.stack.pop()
        elif tag in self.stack:
            self.issues.append(f"mis-nested </{tag}>")
            while self.stack and self.stack[-1] != tag: self.stack.pop()
            if self.stack: self.stack.pop()
c = Check(); c.feed(src)
if c.headings.count(1) != 1: c.issues.append(f"h1 count = {c.headings.count(1)}")
for i in range(1, len(c.headings)):
    if c.headings[i] > c.headings[i-1] + 1: c.issues.append("heading level jump")
left = [t for t in c.stack if t not in ('html','body')]
if left: c.issues.append(f"unclosed tags: {left}")
if c.issues:
    print("[smoke] FAIL:", "; ".join(c.issues)); sys.exit(1)
EOF

# 5. Reveal safety: print must force visibility, gate class must exist
grep -q "@media print" index.html || fail "print visibility override missing"
grep -q "classList.add('rv')" index.html || fail "pre-paint rv gate missing"

# 6. Bilingual and playful-redesign requirements
grep -q 'id="language-toggle"' index.html || fail "missing language toggle"
grep -q 'id="i18n-data"' index.html || fail "missing i18n data"
grep -q 'portfolio-language' index.html || fail "language choice is not persisted"
grep -q "document.documentElement.lang" index.html || fail "document language is not updated"
grep -q 'prefers-reduced-motion: reduce' index.html || fail "reduced-motion treatment missing"
grep -q 'id="shuffle-stickers"' index.html || fail "missing playful sticker interaction"

for art in research-buddy idea-garden hello-orbit; do
  grep -q "assets/illustrations/$art.webp" index.html || fail "missing illustration reference $art.webp"
done

python3 - <<'EOF' || FAIL=1
from html.parser import HTMLParser
import json, re, subprocess, sys

src = open('index.html').read()
match = re.search(r'<script[^>]+id="i18n-data"[^>]*>(.*?)</script>', src, re.S)
if not match:
    print('[smoke] FAIL: i18n JSON script not found')
    sys.exit(1)
try:
    data = json.loads(match.group(1))
except Exception as exc:
    print(f'[smoke] FAIL: invalid i18n JSON: {exc}')
    sys.exit(1)
if set(data) != {'en', 'zh'}:
    print(f'[smoke] FAIL: language set is {set(data)}, expected en and zh')
    sys.exit(1)
en, zh = set(data['en']), set(data['zh'])
if en != zh:
    print(f'[smoke] FAIL: translation keys differ; en-only={sorted(en-zh)}, zh-only={sorted(zh-en)}')
    sys.exit(1)
used = set(re.findall(r'data-i18n(?:-aria)?="([^"]+)"', src))
missing = used - en
if missing:
    print(f'[smoke] FAIL: translation keys used but undefined: {sorted(missing)}')
    sys.exit(1)
empty = [key for key in en if not isinstance(data['en'][key], str) or not data['en'][key].strip() or not isinstance(data['zh'][key], str) or not data['zh'][key].strip()]
if empty:
    print(f'[smoke] FAIL: empty or non-string translations: {sorted(empty)}')
    sys.exit(1)
if len(en) < 40:
    print(f'[smoke] FAIL: only {len(en)} paired strings; bilingual coverage is incomplete')
    sys.exit(1)

ids = set(re.findall(r'\bid="([^"]+)"', src))
missing_targets = sorted({href for href in re.findall(r'href="#([^"]+)"', src) if href not in ids})
if missing_targets:
    print(f'[smoke] FAIL: internal links have no targets: {missing_targets}')
    sys.exit(1)

scripts = re.findall(r'<script([^>]*)>(.*?)</script>', src, re.S)
for attrs, script in scripts:
    if 'application/json' in attrs or 'application/ld+json' in attrs:
        continue
    check = subprocess.run(['node', '--check'], input=script, text=True, capture_output=True)
    if check.returncode:
        print('[smoke] FAIL: executable JavaScript syntax error:', check.stderr.strip())
        sys.exit(1)
EOF

# 7. External links (optional)
if [ "${1:-}" = "--online" ]; then
  grep -o 'href="https\?://[^"]*"' index.html | sed 's/^href="//; s/"$//' | sort -u | while read -r u; do
    code=$(curl -s -o /dev/null -w "%{http_code}" -L -m 12 "$u")
    [ "$code" = "200" ] || echo "[smoke] WARN: HTTP $code $u"
  done
fi

if [ "$FAIL" = "0" ]; then say "PASS"; else say "FAILED"; exit 1; fi
