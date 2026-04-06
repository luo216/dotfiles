---
name: tmux-session-runner
description: Isolated tmux supervisor for long-running and interactive Claude tasks. Use when Claude needs to launch work in a dedicated session, monitor progress, respond to prompts, or interrupt and recover a live shell without attaching.
---

# Tmux Session Runner

Use this skill as Claude's tmux-backed supervisor for any task that is not a short one-shot shell command.

Hard rule:

- Any long-running command, streaming command, prompt-driven command, or multi-step shell workflow should run in this skill.
- After starting a command, do not assume it finished. Poll with `inspect-session` and `inspect-window` until the session returns to `idle` or a blocker appears.
- If output shows a prompt, confirmation request, password request, pager, or hung process, respond explicitly with `send-keys` or stop it with `interrupt-session`.

Default model:

- one task = one session
- one session = one `main` shell
- keep all follow-up input in that same shell so state stays intact
- always create or confirm the session before sending commands

By default this skill uses an isolated tmux server:

- socket path: `/tmp/claude-supervisor-tmux.sock`
- config file: `/dev/null`

That keeps Claude's automation separate from the operator's normal tmux environment.

## Main Commands

Use only these commands in normal work:

- `ensure-session --session NAME`
- `list-sessions`
- `send-command --session NAME --command CMD`
- `send-keys --session NAME --text TEXT [--no-enter]`
- `interrupt-session --session NAME`
- `inspect-session --session NAME`
- `inspect-window --session NAME --lines 100`

Compatibility:

- `run-command` remains an alias of `send-command`

Expected sequence:

1. `list-sessions` when you need discovery
2. `ensure-session --session NAME`
3. `send-command --session NAME --command CMD`
4. poll with `inspect-session` and `inspect-window`
5. if the task needs input, use `send-keys`
6. if the task is wedged or should stop, use `interrupt-session`

## Session Naming

Keep names short and tied to the actual task. Prefer:

- `pytest-api`
- `frontend-dev`
- `ssh-tail`
- `db-migrate`
- `release-check`

Avoid vague names like `test`, `work`, or `temp`.

## Practical Pattern

For real work, prefer this pattern:

1. Create or reuse the task session.
2. Send the top-level command into that session's `main` shell.
3. Include `cd` in the command string when the task must run in another directory.
4. Poll with `inspect-session` and `inspect-window`.
5. If the process asks for input or confirmation, answer with `send-keys`.
6. If the process must stop, use `interrupt-session`, then inspect again.

Example:

```bash
scripts/tmux-session-runner.sh ensure-session --session pytest-api
scripts/tmux-session-runner.sh send-command --session pytest-api --command "cd /workspace/project && pytest tests/api -q"
sleep 15
scripts/tmux-session-runner.sh inspect-session --session pytest-api
scripts/tmux-session-runner.sh inspect-window --session pytest-api --lines 120
```

Interactive example:

```bash
scripts/tmux-session-runner.sh ensure-session --session release-check
scripts/tmux-session-runner.sh send-command --session release-check --command "cd /workspace/project && ./scripts/release.sh"
sleep 5
scripts/tmux-session-runner.sh inspect-window --session release-check --lines 80
scripts/tmux-session-runner.sh send-keys --session release-check --text "y"
```

Interrupt example:

```bash
scripts/tmux-session-runner.sh interrupt-session --session frontend-dev
scripts/tmux-session-runner.sh inspect-session --session frontend-dev
scripts/tmux-session-runner.sh inspect-window --session frontend-dev --lines 80
```

## Recommended Command Style

Prefer these patterns inside `send-command`:

- use `cd /target/path && ...` so the session stays self-contained
- use one clear top-level command per session
- keep stdout/stderr visible
- prefer explicit flags over shell aliases
- for repeated observation, poll instead of attaching interactively

Prefer these patterns for interactive control:

- use `send-keys --text "value"` for prompt answers
- use `send-keys --text " "` for pagers waiting on a space
- use `send-keys --text "q"` for pagers or REPL exits
- use `send-keys --text ""` without `--no-enter` when you only need Enter
- use `interrupt-session` before replacing a long-running foreground process

## Common Claude Workloads

Use tmux for these patterns:

- test suites that may run for more than a few seconds
- build commands such as `npm run build`, `cargo test`, `go test`, `pytest`, `nix build`
- dev servers and file watchers
- SSH sessions, remote tails, and remote diagnostics
- install or migration scripts that may ask for confirmation
- REPLs or CLIs that need several follow-up inputs

Examples:

```bash
scripts/tmux-session-runner.sh ensure-session --session frontend-dev
scripts/tmux-session-runner.sh send-command --session frontend-dev --command "cd /workspace/app && npm run dev"
sleep 10
scripts/tmux-session-runner.sh inspect-window --session frontend-dev --lines 120
```

```bash
scripts/tmux-session-runner.sh ensure-session --session ssh-tail
scripts/tmux-session-runner.sh send-command --session ssh-tail --command "ssh -o BatchMode=yes ops@host 'journalctl -fu app.service'"
sleep 15
scripts/tmux-session-runner.sh inspect-window --session ssh-tail --lines 120
```

```bash
scripts/tmux-session-runner.sh ensure-session --session repl
scripts/tmux-session-runner.sh send-command --session repl --command "cd /workspace/app && node"
sleep 2
scripts/tmux-session-runner.sh send-keys --session repl --text "await healthcheck()"
scripts/tmux-session-runner.sh inspect-window --session repl --lines 80
```

## Monitoring Rhythm

- quick command: wait 5-10 seconds, inspect once
- medium command: wait 15-30 seconds between inspections
- long build or streaming command: wait 30-60 seconds between inspections
- if output clearly asks for input, inspect immediately after responding

## Status Model

`inspect-session` reports only one window: `main`.

- `idle`: foreground process is a shell
- `busy`: some other command is running
- `dead`: the pane exited; the next `send-command` or `send-keys` will respawn it automatically

## Notes

- By default the skill uses `/tmp/claude-supervisor-tmux.sock` and ignores user tmux config via `/dev/null`.
- Pass `TMUX_SOCKET_PATH`, `TMUX_SOCKET_NAME`, or `TMUX_CONFIG_PATH` only when you intentionally want different behavior.
- Keep the session name explicit in user-facing explanations so the operator can attach manually if needed.
