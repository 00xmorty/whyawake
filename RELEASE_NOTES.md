# v0.2.0

Feature release: explain *why* the Mac woke, and how often per night, without changing anything.

- `--since DAYS` (default 7) bounds the report to a window measured back from the newest wake event in the input.
- Plain-language cause dictionary for common `due to` / `Wake reason` codes: `SMC.OutboxNotEmpty`, `wifibt`, `ARPT`, `RTC`/`EC.RTC`, `NUB.SPMISw3IRQ`, `EC.DarkPME`, `EC.LidOpen`, `XHC*`/`USB`, `MAGICWAKE`, `UserActivity`, power button.
- Each wake group now names a *candidate* `pmset` setting to compare (`tcpkeepalive`, `networkoversleep`, `womp`, `powernap`, `standby`) and is explicitly labelled as not a verified cause.
- Per-night wake accounting plus an overnight tally (22:00–07:00), so "three wakes per night" is visible instead of a flat group count.
- Wake codes are matched up to a whitespace boundary, so `RTC/Maintenance` is no longer truncated to `RTC`.
- Honest empty path: no wake events in the input is reported as such, with the `sleep 0` / log-rotation explanation, instead of a silent blank section.
- `--since 0` is rejected; `--json` now includes `version` and a `window` block with first/last event, nights, overnight count and untimed-line count.
- Still dependency-free Python 3, strictly read-only: no `sudo`, no setting writes, no network, no telemetry.

Verified locally on macOS 26.6.2 with fixture logs, a real 8,700-line `pmset -g log` capture and real `pmset -g assertions` output.

# v0.1.1

Patch release: recognize `XHC*` wake reasons as USB-controller clues so the printed next check matches the documented behavior.

- Reads current named sleep assertions from `pmset -g assertions`.
- Groups wake clues from `pmset -g log`.
- Offers conservative next checks without changing settings.
- Supports JSON and saved-input files for repeatable analysis.
- Dependency-free Python 3; tested on macOS and Linux fixtures.
