# Claude Code 本地配置

这个目录用于直接覆盖本机的 Claude Code 配置。

执行脚本：

```bash
bash ./setup.sh <api-key>
```

脚本会写入以下文件：

- `~/.claude/settings.json`

如果原文件已存在，脚本会先备份：

- `~/.claude/settings.json.bak-setup`

## BaseURL

```json
{
  "ANTHROPIC_BASE_URL": "https://api.minimaxi.com/anthropic"
}
```

## Auth Token

API Key 由用户传入，不在脚本中硬编码。

## MCP 配置

脚本会自动添加 MiniMax MCP：

```bash
claude mcp add -s user MiniMax --env MINIMAX_API_KEY="<api-key>" --env MINIMAX_API_HOST=https://api.minimaxi.com -- uvx minimax-coding-plan-mcp -y
```

## tmux skill

当前目录包含一个重要 skill：

- `./tmux-session-runner`

用途：

- 让 Claude Code 在独立 tmux 会话中运行长任务
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
