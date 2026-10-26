#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m py_compile whyawake
FIX=(--assertions-file tests/fixtures/assertions.txt --log-file tests/fixtures/log.txt)

out="$(python3 whyawake "${FIX[@]}")"
grep -q 'zoom.us (pid 424)' <<<"$out"
grep -q 'EC.DarkPME (Maintenance) — 2 event(s)' <<<"$out"
grep -q 'XHC1 — 1 event(s)' <<<"$out"
grep -q 'Disconnect one USB device at a time' <<<"$out"
grep -q 'SMC.OutboxNotEmpty' <<<"$out"
grep -q 'radio traffic (Wi-Fi/Bluetooth)' <<<"$out"
grep -q 'scheduled alarm/maintenance wake' <<<"$out"
grep -q 'Overnight wakes (22:00-07:00): 7' <<<"$out"
grep -q -- '- night of 2026-08-26: 4 event(s)' <<<"$out"
grep -q -- '- night of 2026-08-27: 2 event(s)' <<<"$out"
grep -q 'Nothing was changed' <<<"$out"

json="$(python3 whyawake "${FIX[@]}" --json)"
python3 - "$json" <<'PY'
import json, sys
d = json.loads(sys.argv[1])
assert d["read_only"] and d["version"] == "0.2.0"
assert len(d["sleep_blockers"]) == 2
assert d["window"]["events"] == 7 and d["window"]["overnight"] == 7
assert len(d["window"]["nights"]) == 3
first = d["wake_reasons"][0]
assert first["count"] == 2 and first["reason"] == "EC.DarkPME (Maintenance)"
smc = [g for g in d["wake_reasons"] if g["reason"].startswith("SMC")]
assert smc and "tcpkeepalive" in smc[0]["candidate_setting"]
PY

narrow="$(python3 whyawake "${FIX[@]}" --since 1)"
grep -q 'Window: last 1 day(s) — 3 event(s)' <<<"$narrow"
if grep -q 'night of 2026-08-22' <<<"$narrow"; then
  echo 'FAIL: --since 1 kept an out-of-window night' >&2; exit 1
fi

empty="$(python3 whyawake --log-file tests/fixtures/assertions.txt)"
grep -q 'No wake events found in the parsed input.' <<<"$empty"
grep -q 'not evidence that your Mac does not wake' <<<"$empty"

if python3 whyawake --log-file tests/fixtures/log.txt --since 0 >/dev/null 2>&1; then
  echo 'FAIL: --since 0 should be rejected' >&2; exit 1
fi

diff <(python3 whyawake "${FIX[@]}") sample-output.txt >/dev/null
python3 whyawake --version | grep -q '0.2.0'
echo 'PASS: sample-output matches live run; syntax, assertions, wake causes, per-night window, empty path, guard, version'
