# WhyAwake

WhyAwake turns macOS `pmset` sleep assertions and wake logs into a compact, readable report. It groups repeated wake clues and shows which named processes currently claim to prevent idle system sleep.

## Run

Requires macOS and Python 3 (included with Xcode Command Line Tools or install separately).

```sh
curl -LO https://github.com/00xmorty/whyawake/releases/latest/download/whyawake
chmod +x whyawake
./whyawake
```

JSON output:

```sh
./whyawake --json
```

Analyze previously saved outputs (also works on Linux):

```sh
pmset -g assertions > assertions.txt
pmset -g log > pmset-log.txt
./whyawake --assertions-file assertions.txt --log-file pmset-log.txt
```

## Example

```text
WhyAwake (read-only)
Active sleep blocker clues: 1
- zoom.us (pid 424): Zoom Meeting audio
Wake reason groups: 1
- XHC1 — 3 event(s)
  Next: Disconnect one USB device at a time and compare a later report.
Nothing was changed. Clues are not proof of a faulty app or device.
```

## Safety

- Strictly read-only: no `sudo`, settings writes, process kills, sleep/wake actions, network requests, or telemetry.
- Suggested checks are manual, reversible observations; WhyAwake never executes them.
- Review output before sharing. It can contain process names, PIDs, timestamps, hardware hints, and activity patterns.

## Limitations

- A `pmset` reason is a correlation clue, not proof that an app, accessory, or subsystem is defective.
- Log wording varies by macOS and hardware. Unknown formats may not be counted.
- The MVP reads the full available `pmset -g log`; it does not apply an exact time window.
- Named assertions may omit blockers that macOS reports only in summary form.
- Live inspection is macOS-only. Saved-input parsing is supported on macOS and Linux.

## Development

```sh
bash tests/test.sh
```

MIT licensed.
