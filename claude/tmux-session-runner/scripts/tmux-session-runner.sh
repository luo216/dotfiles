#!/usr/bin/env bash

set -euo pipefail

DEFAULT_TMUX_SOCKET_PATH="${TMPDIR:-/tmp}/claude-supervisor-tmux.sock"
DEFAULT_TMUX_CONFIG_PATH="/dev/null"

tmux_cmd() {
  local config_path="${TMUX_CONFIG_PATH:-$DEFAULT_TMUX_CONFIG_PATH}"
  local -a cmd=(tmux -f "$config_path")
  if [[ -n "${TMUX_SOCKET_PATH:-}" ]]; then
    cmd+=(-S "$TMUX_SOCKET_PATH")
  elif [[ -n "${TMUX_SOCKET_NAME:-}" ]]; then
    cmd+=(-L "$TMUX_SOCKET_NAME")
  else
    cmd+=(-S "$DEFAULT_TMUX_SOCKET_PATH")
  fi
  "${cmd[@]}" "$@"
}

die() {
  echo "error: $*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage:
  tmux-session-runner.sh ensure-session --session NAME
  tmux-session-runner.sh list-sessions
  tmux-session-runner.sh send-command --session NAME --command CMD
  tmux-session-runner.sh send-keys --session NAME [--text TEXT] [--no-enter]
  tmux-session-runner.sh interrupt-session --session NAME
  tmux-session-runner.sh inspect-session --session NAME
  tmux-session-runner.sh inspect-window --session NAME [--lines N]

Defaults:
  socket path: /tmp/claude-supervisor-tmux.sock
  config file: /dev/null

Session naming:
  Prefer short, task-specific names such as:
  - pytest-api
  - frontend-dev
  - ssh-tail
  - db-migrate
EOF
}

session_exists() {
  local session="$1"
  tmux_cmd has-session -t "$session" 2>/dev/null
}

require_session() {
  local session="$1"
  session_exists "$session" || die "session '$session' does not exist"
}

pane_dead() {
  local session="$1"
  tmux_cmd display-message -p -t "${session}:main" '#{pane_dead}' 2>/dev/null || echo 0
}

prime_shell() {
  local session="$1"
  tmux_cmd send-keys -t "${session}:main" Enter
  sleep 0.2
}

ensure_session() {
  local session="$1"
  if session_exists "$session"; then
    echo "$session"
    return 0
  fi

  if ! tmux_cmd new-session -d -s "$session" -n main 2>/dev/null; then
    session_exists "$session" || die "failed to create session '$session'"
    echo "$session"
    return 0
  fi

  tmux_cmd set-option -wq -t "${session}:main" remain-on-exit on
  prime_shell "$session"
  echo "$session"
}

ensure_live_pane() {
  local session="$1"
  require_session "$session"

  if [[ "$(pane_dead "$session")" == "1" ]]; then
    tmux_cmd respawn-pane -k -t "${session}:main"
    tmux_cmd set-option -wq -t "${session}:main" remain-on-exit on
    prime_shell "$session"
  fi
}

list_sessions() {
  tmux_cmd list-sessions
}

send_command() {
  local session="$1"
  local command="$2"
  [[ -n "$command" ]] || die "--command is required"
  ensure_live_pane "$session"
  tmux_cmd send-keys -t "${session}:main" "$command" Enter
  echo "${session}:main"
}

send_keys() {
  local session="$1"
  local text="$2"
  local with_enter="$3"
  ensure_live_pane "$session"

  if [[ -n "$text" ]]; then
    tmux_cmd send-keys -l -t "${session}:main" "$text"
  fi
  if [[ "$with_enter" == "1" ]]; then
    tmux_cmd send-keys -t "${session}:main" Enter
  fi
  echo "${session}:main"
}

interrupt_session() {
  local session="$1"
  ensure_live_pane "$session"
  tmux_cmd send-keys -t "${session}:main" C-c
  echo "${session}:main"
}

inspect_session() {
  local session="$1"
  local pane_dead_value current status
  require_session "$session"
  pane_dead_value="$(pane_dead "$session")"
  current="$(tmux_cmd display-message -p -t "${session}:main" '#{pane_current_command}')"

  if [[ "$pane_dead_value" == "1" ]]; then
    status="dead"
  elif [[ "$current" =~ ^(bash|zsh|sh|fish|nu|ash|dash)$ ]]; then
    status="idle"
  else
    status="busy"
  fi

  echo "session: $session"
  printf '%-12s %-8s %s\n' "window" "status" "current"
  printf '%-12s %-8s %s\n' "main" "$status" "$current"
}

inspect_window() {
  local session="$1"
  local window="$2"
  local lines="$3"
  require_session "$session"
  tmux_cmd capture-pane -t "${session}:${window}" -p -S "-${lines}"
}

command_name="${1:-}"
if [[ "$command_name" == "-h" || "$command_name" == "--help" ]]; then
  usage
  exit 0
fi
[[ -n "$command_name" ]] || {
  usage
  exit 1
}
shift

session=""
window="main"
command=""
text=""
lines="100"
with_enter="1"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session)
      session="${2:-}"
      shift 2
      ;;
    --window)
      window="${2:-}"
      shift 2
      ;;
    --command)
      command="${2:-}"
      shift 2
      ;;
    --text)
      text="${2:-}"
      shift 2
      ;;
    --lines)
      lines="${2:-}"
      shift 2
      ;;
    --no-enter)
      with_enter="0"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument '$1'"
      ;;
  esac
done

case "$command_name" in
  ensure-session)
    [[ -n "$session" ]] || die "--session is required"
    ensure_session "$session"
    ;;
  list-sessions)
    list_sessions
    ;;
  send-command|run-command)
    [[ -n "$session" ]] || die "--session is required"
    send_command "$session" "$command"
    ;;
  send-keys)
    [[ -n "$session" ]] || die "--session is required"
    send_keys "$session" "$text" "$with_enter"
    ;;
  interrupt-session)
    [[ -n "$session" ]] || die "--session is required"
    interrupt_session "$session"
    ;;
  inspect-session)
    [[ -n "$session" ]] || die "--session is required"
    inspect_session "$session"
    ;;
  inspect-window)
    [[ -n "$session" ]] || die "--session is required"
    inspect_window "$session" "$window" "$lines"
    ;;
  *)
    usage
    die "unknown command '$command_name'"
    ;;
esac
