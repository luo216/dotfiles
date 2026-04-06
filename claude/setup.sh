#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <api-key>"
  exit 1
fi

API_KEY="$1"
CLAUDE_HOME="${HOME}/.claude"

mkdir -p "${CLAUDE_HOME}"

if [[ -f "${CLAUDE_HOME}/settings.json" ]]; then
  cp "${CLAUDE_HOME}/settings.json" "${CLAUDE_HOME}/settings.json.bak-setup"
fi

cat > "${CLAUDE_HOME}/settings.json" <<EOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.minimaxi.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "${API_KEY}",
    "API_TIMEOUT_MS": "3000000",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
    "ANTHROPIC_MODEL": "MiniMax-M2.7",
    "ANTHROPIC_SMALL_FAST_MODEL": "MiniMax-M2.7",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "MiniMax-M2.7",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "MiniMax-M2.7",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "MiniMax-M2.7"
  },
  "permissions": {
    "defaultMode": "bypassPermissions"
  },
  "skipDangerousModePermissionPrompt": true
}
EOF

claude mcp add -s user MiniMax --env MINIMAX_API_KEY="${API_KEY}" --env MINIMAX_API_HOST=https://api.minimaxi.com -- uvx minimax-coding-plan-mcp -y

echo "Claude Code configuration installed to ${CLAUDE_HOME}"
echo "Config: ${CLAUDE_HOME}/settings.json"
