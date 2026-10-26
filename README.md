# WhyAwake

WhyAwake helps Mac users investigate sleep blockers and repeated wake reasons without changing power settings. It groups wake clues, explains what the raw `due to` wake codes mean, counts wakes per night, and lists named processes currently claiming to prevent idle sleep.

**New in v0.2.0:** a bounded `--since` window, a plain-language cause dictionary for wake codes, and per-night wake accounting with an overnight tally — still strictly read-only.

![Terminal demo — example output](https://github.com/00xmorty/whyawake/releases/download/v0.1.1/whyawake-demo.gif)

## Why this tool

Reading `pmset -g assertions` and `pmset -g log` by hand means matching process assertions to repeated wake messages, then decoding lines like `DarkWake from Deep Idle [CDNP] : due to SMC.OutboxNotEmpty smc.70070000 wifibt wlan/ Using BATT`. WhyAwake turns that into one pass/fail-free report: which assertions are active now, why the Mac woke recently, how many wakes happened per night, and which `pmset` setting is worth comparing next. It does not change power settings, does not execute fixes, and does not claim to prove a cause.

## Install

In an empty directory, download the single executable release asset and make it executable:

```sh
curl -fsSLO https://github.com/00xmorty/whyawake/releases/latest/download/whyawake && chmod +x whyawake
```

This downloads a file; it does not execute a remote install script or change your PATH. Review it before running. [Latest release](https://github.com/00xmorty/whyawake/releases/latest) · [Source](./whyawake).

## Usage

```sh
./whyawake               # last 7 days of wake clues by default
./whyawake --since 3     # narrower window
./whyawake --json        # machine-readable report
```

Analyze previously saved outputs (also works on Linux):

```sh
pmset -g assertions > assertions.txt
pmset -g log > pmset-log.txt
./whyawake --assertions-file assertions.txt --log-file pmset-log.txt
```

## Example output

Illustrative fixture data; paths, process IDs, timings and sizes are examples, not claims about your Mac.

```text
WhyAwake 0.2.0 (read-only)
Active sleep blocker clues: 2
- zoom.us (pid 424): Zoom Meeting audio
- caffeinate (pid 912): caffeinate command-line tool
Wake reason groups: 6
- EC.DarkPME (Maintenance) — 2 event(s)
  Cause: platform maintenance wake (DarkWake)
  Candidate setting to compare: powernap, standby (not a verified cause)
  Next: Treat as housekeeping clue; compare counts across nights.
- SMC.OutboxNotEmpty — 1 event(s)
  Cause: radio traffic (Wi-Fi/Bluetooth) arrived while asleep
  Candidate setting to compare: tcpkeepalive, networkoversleep (not a verified cause)
  Next: Compare one night with Wi-Fi off; do not change settings from a single report.
- XHC1 — 1 event(s)
  Cause: a USB device woke the Mac
  Next: Disconnect one USB device at a time and compare a later report.
(3 more wake groups omitted)
Window: last 7 day(s) — 7 event(s) from 2026-08-23T02:00 to 2026-08-28T04:30
Nights with wakes: 3
- night of 2026-08-22: 1 event(s)
- night of 2026-08-26: 4 event(s)
- night of 2026-08-27: 2 event(s)
Overnight wakes (22:00-07:00): 7
Nothing was changed. Clues are not proof of a faulty app, device, or subsystem.
```

## How to read it

- **Sleep blocker clues** are the *current* snapshot from `pmset -g assertions`.
- **Wake reason groups** are *historical* correlation clues from `pmset -g log`.
- **Nights with wakes** buckets each wake by local night: a wake before 12:00 counts for the previous calendar night, so "night of 2026-08-26" includes wakes up to 2026-08-27 11:59.
- **Candidate setting to compare** names the `pmset` setting that usually feeds that wake code (`tcpkeepalive`, `networkoversleep`, `womp`, `powernap`, `standby`). It is a comparison target, not a diagnosis, and WhyAwake never changes it.
- Change one variable at a time, then compare a later report. One night is not evidence.

An empty result is a valid result: a Mac can have `sleep 0`, or the `pmset` log can be rotated. WhyAwake says so explicitly instead of inventing data.

## Safety

- Strictly read-only: no `sudo`, settings writes, process kills, sleep/wake actions, network requests, or telemetry.
- Suggested checks are manual, reversible observations; WhyAwake never executes them.
- Review output before sharing. It can contain process names, PIDs, timestamps, hardware hints, and activity patterns.

## Limitations

- A `pmset` reason is a correlation clue, not proof that an app, accessory, or subsystem is defective.
- Log wording varies by macOS and hardware. Unrecognised codes are reported as unrecognised instead of being guessed; wake lines without a parseable timestamp are counted but excluded from per-night totals.
- `--since N` counts back from the **newest wake event in the input**, not from the current clock, so saved logs behave predictably.
- WhyAwake cannot see inside Apple's closed-source wake decisions, does not measure battery drain, and does not estimate power cost.
- Named assertions may omit blockers that macOS reports only in summary form.
- Live inspection is macOS-only. Saved-input parsing is supported on macOS and Linux.

## Requirements

- Tested on macOS 26.6.2.
- Python 3.9+ with the standard library and macOS `pmset`; Python 3.9 tested.
- Saved-input parsing also works on Linux.
- Single executable file; no sudo or package manager is needed to run it.

## Development

```sh
bash tests/test.sh
```

## License

[MIT](LICENSE).
