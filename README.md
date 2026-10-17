WhyAwake helps Mac users investigate sleep blockers and repeated wake reasons without changing power settings.

# whyawake

![Terminal demo — example output](https://github.com/00xmorty/whyawake/releases/download/v0.1.1/whyawake-demo.gif)

## Install

In an empty directory, download the single executable release asset and make it executable:

```sh
curl -fsSLO https://github.com/00xmorty/whyawake/releases/download/v0.1.1/whyawake && chmod +x whyawake
```

This downloads a file; it does not execute a remote install script or change your PATH. Review it before running. [Release and asset](https://github.com/00xmorty/whyawake/releases/tag/v0.1.1) · [Source](./whyawake).

## Usage

```sh
./whyawake
./whyawake --json
./whyawake --assertions-file tests/fixtures/assertions.txt --log-file tests/fixtures/log.txt
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

## Requirements

- macOS 26.6.2 verified; older releases have not been verified in this preparation pass.
- Python 3 with the standard library and macOS pmset. Fixture parsing also runs on Linux. Python 3.9 is verified on M4.
- No sudo or package manager is required to run the diagnostic.

## Safety and limits

Read-only diagnostics: no deletion, settings changes, background agent, process termination or automatic repair. It does not read file contents (except explicitly supplied saved pmset text). No telemetry or network calls are made by the diagnostic. Downloading with curl is a separate install step.

Wake reasons are correlation clues, not proof of a faulty device or application. Log formats differ across macOS releases; unknown formats may be missed. It reads the available pmset log, not an exact time window.

Review reports before sharing: process names, IDs and activity patterns may be sensitive. The GIF uses illustrative data; sample/fixture mode does not diagnose your current machine.

## Development

```sh
bash tests/test.sh
```

## License

[MIT](LICENSE).
