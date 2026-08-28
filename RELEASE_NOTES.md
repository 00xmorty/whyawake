# v0.1.1

Patch release: recognize `XHC*` wake reasons as USB-controller clues so the printed next check matches the documented behavior.

- Reads current named sleep assertions from `pmset -g assertions`.
- Groups wake clues from `pmset -g log`.
- Offers conservative next checks without changing settings.
- Supports JSON and saved-input files for repeatable analysis.
- Dependency-free Python 3; tested on macOS and Linux fixtures.
