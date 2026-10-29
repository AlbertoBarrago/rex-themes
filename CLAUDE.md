# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A library of color themes for the Rex terminal plus `bin/rex-theme`, a single-file Python CLI (standard library only, keep it dependency-free). No build step, no test suite.

## Commands

```sh
bin/rex-theme list | use <name> | try <name> [-b BLOCK] | reset [-b BLOCK] | current
bin/rex-theme add "<Upstream Name>" [name]    # from iTerm2-Color-Schemes ghostty/ dir
bin/rex-theme add --file <path> <name>        # local Ghostty file
rex actions --json                            # live schema of server/block actions
rex -C <client> actions --json                # live schema of Rex.app (client) actions
```

Check that every theme is accepted by Rex (validation is server side):

```sh
for n in $(bin/rex-theme list | cut -d' ' -f1); do bin/rex-theme try "$n" >/dev/null || echo "FAIL $n"; done; bin/rex-theme reset
```

## Architecture

Two Rex mechanisms, two files per theme in `themes/`:

- `<name>.ghostty` is the source of truth. `use` passes its absolute path to the **client** action `client.theme.import`, which makes it a persistent app theme. Client actions fail unless Rex.app has Remote Control enabled (Settings, Rex Server).
- `<name>.json` is generated from the `.ghostty` by `add` and holds **only** the arguments of the **block** action `com.superlogical.terminal.set_theme` (`palette` as `index=#RRGGBB` strings, `background`, `foreground`, `cursor`, `scheme`). That action has `additionalProperties: false`: never add metadata keys. `try` uses it; it colors one block and is not persisted.
- If you edit a `.ghostty` by hand, regenerate the JSON with `bin/rex-theme add --file themes/<name>.ghostty <name>`.
- `current` reads `Workspace.darkThemeID` / `Workspace.lightThemeID` from the `com.superlogical.rex` defaults domain. Built-in app themes (e.g. `merino-dark`) are defined in `Rex Beta.app/.../SuperUI_SuperDesignTokens.bundle/.../themes.json`; they are not part of this library.
- New themes need a row in the README Themes table.

## Version control

`jj` (colocated with git), one bookmark per feature. Remote: `AlbertoBarrago/rex-themes` (public).
