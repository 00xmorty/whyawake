#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m py_compile whyawake
out="$(python3 whyawake --assertions-file tests/fixtures/assertions.txt --log-file tests/fixtures/log.txt)"
grep -q 'zoom.us (pid 424)' <<<"$out"
grep -q 'EC.DarkPME (Maintenance) — 2 event(s)' <<<"$out"
grep -q 'XHC1 — 1 event(s)' <<<"$out"
json="$(python3 whyawake --assertions-file tests/fixtures/assertions.txt --log-file tests/fixtures/log.txt --json)"
python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["read_only"] and len(d["sleep_blockers"])==2 and d["wake_reasons"][0]["count"]==2' <<<"$json"
grep -q 'Disconnect one USB device at a time' <<<"$out"
python3 whyawake --version | grep -q '0.1.1'
echo 'PASS: syntax, assertion parsing, wake grouping, JSON, and version'
