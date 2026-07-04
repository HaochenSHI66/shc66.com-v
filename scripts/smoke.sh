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
        if tag not in ('br','img','meta','link','input','hr'): self.stack.append(tag)
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

# 6. External links (optional)
if [ "${1:-}" = "--online" ]; then
  grep -o 'href="https\?://[^"]*"' index.html | sed 's/^href="//; s/"$//' | sort -u | while read -r u; do
    code=$(curl -s -o /dev/null -w "%{http_code}" -L -m 12 "$u")
    [ "$code" = "200" ] || echo "[smoke] WARN: HTTP $code $u"
  done
fi

if [ "$FAIL" = "0" ]; then say "PASS"; else say "FAILED"; exit 1; fi
