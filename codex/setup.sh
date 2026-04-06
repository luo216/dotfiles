#!/usr/bin/env bash

set -euo pipefail

CODEX_HOME="${HOME}/.codex"
SKILLS_DIR="${CODEX_HOME}/skills"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_SKILL_SRC="${SOURCE_DIR}/tmux-session-runner"
TMUX_SKILL_DST="${SKILLS_DIR}/tmux-session-runner"

mkdir -p "${CODEX_HOME}" "${SKILLS_DIR}"

if [[ -f "${CODEX_HOME}/config.toml" ]]; then
  cp "${CODEX_HOME}/config.toml" "${CODEX_HOME}/config.toml.bak-setup"
fi

if [[ -f "${CODEX_HOME}/auth.json" ]]; then
  cp "${CODEX_HOME}/auth.json" "${CODEX_HOME}/auth.json.bak-setup"
fi

cat > "${CODEX_HOME}/config.toml" <<'EOF'
model = "gpt-5.4"
model_reasoning_effort = "medium"
personality = "pragmatic"
approvals_reviewer = "user"
openai_base_url = "http://127.0.0.1:8317/v1"

[projects."/home/steve"]
trust_level = "trusted"

[projects."/home/steve/Share/dotfiles"]
trust_level = "trusted"

[notice]
hide_full_access_warning = true

[notice.model_migrations]
"gpt-5.1-codex-max" = "gpt-5.2-codex"
"gpt-5.3-codex" = "gpt-5.4"

[features]
js_repl = true
tui_app_server = true
prevent_idle_sleep = true
EOF

cat > "${CODEX_HOME}/auth.json" <<'EOF'
{
  "auth_mode": "apikey",
  "OPENAI_API_KEY": "TAoAN93hhVphA6sk2Jyo7y7G"
}
EOF

rm -rf "${TMUX_SKILL_DST}"
cp -R "${TMUX_SKILL_SRC}" "${TMUX_SKILL_DST}"

echo "Codex configuration installed to ${CODEX_HOME}"
echo "Config: ${CODEX_HOME}/config.toml"
echo "Auth: ${CODEX_HOME}/auth.json"
echo "Skill: ${TMUX_SKILL_DST}"
