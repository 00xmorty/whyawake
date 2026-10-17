# WhyAwake

WhyAwake helps Mac users investigate sleep blockers and repeated wake reasons without changing power settings.

![Terminal demo — example output](https://github.com/00xmorty/whyawake/releases/download/v0.1.1/whyawake-demo.gif)

## Why this tool

Reading `pmset -g assertions` and `pmset -g log` by hand means matching process assertions to repeated wake messages. WhyAwake groups wake clues and lists named processes currently claiming to prevent idle sleep in a compact report; it does not change power settings or prove a cause.

## Install

In an empty directory, download the single executable release asset and make it executable:

```sh
curl -fsSLO https://github.com/00xmorty/whyawake/releases/download/v0.1.1/whyawake && chmod +x whyawake
```

This downloads a file; it does not execute a remote install script or change your PATH. Review it before running. [Release and asset](https://github.com/00xmorty/whyawake/releases/tag/v0.1.1) · [Source](./whyawake).

## Usage

```sh
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

## Example output

Illustrative fixture data; paths, process IDs, timings and sizes are examples, not claims about your Mac.

```text
WhyAwake (read-only)
Active sleep blocker clues: 2
- zoom.us (pid 424): Zoom Meeting audio
- caffeinate (pid 912): caffeinate command-line tool
Wake reason groups: 3
- EC.DarkPME (Maintenance) — 2 event(s)
  Next: This may be scheduled maintenance; compare frequency before changing settings.
- XHC1 — 1 event(s)
  Next: Disconnect one USB device at a time and compare a later report.
- RTC — 1 event(s)
  Next: Check Bluetooth/network wake settings and disconnect accessories one at a time.
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
