# OpenCode Integrations

[OpenCode](https://opencode.ai) is an AI coding agent you can run locally or in CI, connected to the team's shared model endpoint at `ai.camer.digital`.

## Available Guides

| Guide | What it covers |
|-------|---------------|
| [VSCode](01-vscode.md) | Extension install, keyboard shortcuts, Plan/Build mode |
| [IntelliJ](02-intellij.md) | Terminal-based usage, editor config, split panes |
| [CLI](03-cli.md) | TUI commands, non-interactive mode, session management, web UI |
| [GitHub Actions](04-github-pr-reviews.md) | Composite action setup, secrets, PR/issue-comment workflow |

## Common Prerequisites

### Install OpenCode CLI

```bash
npm install -g opencode-ai
```

### Authenticate against the team endpoint

```bash
opencode auth login https://ai.camer.digital/opencode
```

A browser tab opens for SSO. After login, return to the terminal and select your model.

## Governance Note

OpenCode usage is subject to the [AI Working Agreement](../../12-ai-working-agreement.md). All AI-generated output must be human-verified before merging. Declare AI usage in your PR using the [PR template](../../04-pull-request-template.md).
