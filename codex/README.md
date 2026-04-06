# Codex 本地配置

这个目录用于直接覆盖本机的 Codex 配置。

执行脚本：

```bash
bash ./setup.sh
```

脚本会写入以下文件：

- `~/.codex/config.toml`
- `~/.codex/auth.json`
- `~/.codex/skills/tmux-session-runner`

如果原文件已存在，脚本会先备份：

- `~/.codex/config.toml.bak-setup`
- `~/.codex/auth.json.bak-setup`

## baseURL

写入到 `~/.codex/config.toml` 的配置为：

```toml
openai_base_url = "http://127.0.0.1:8317/v1"
```

## API Key

写入到 `~/.codex/auth.json` 的配置为：

```json
{
  "auth_mode": "apikey",
  "OPENAI_API_KEY": "TAoAN93hhVphA6sk2Jyo7y7G"
}
```

## tmux skill

当前目录包含一个重要 skill：

- `./tmux-session-runner`

用途：

- 让 Codex 在独立 tmux 会话中运行长任务
- 适合测试、构建、交互式命令、持续运行服务
- 支持轮询状态、发送输入、中断任务

核心文件：

- `./tmux-session-runner/SKILL.md`
- `./tmux-session-runner/scripts/tmux-session-runner.sh`

常用命令：

- `ensure-session --session NAME`
- `send-command --session NAME --command CMD`
- `send-keys --session NAME --text TEXT`
- `inspect-session --session NAME`
- `inspect-window --session NAME --lines 100`
- `interrupt-session --session NAME`
