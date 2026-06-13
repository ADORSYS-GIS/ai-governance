# OpenCode — CLI Integration

## Setup

### Install

```bash
npm install -g opencode-ai
```

### Authenticate

```bash
opencode auth login https://ai.camer.digital/opencode
```

Browser opens for authentication. Login, return to terminal, select model.

## Configuration

### Initialize project context (AGENTS.md)

```bash
opencode
/init
```

## Usage

### Start OpenCode

```bash
# Current directory
opencode

# Specific directory
opencode /path/to/project

# Continue the last session
opencode --continue
```

### TUI Commands

| Command | Purpose |
|---------|---------|
| `/help` | Show help |
| `/init` | Create AGENTS.md |
| `/connect` | Configure provider |
| `/models` | List available models |
| `/share` | Share session |
| `/undo` | Undo last change |
| `/new` | Start a new session |

### File References

```
Explain @src/utils/parser.ts
Refactor @src/api.ts using async/await
```

### Shell Commands

Run shell commands from within the TUI:

```
!npm test
!git status
```

### Non-Interactive Mode

```bash
# Single prompt
opencode run "Explain async/await"

# With a file
opencode run --file src/main.ts "Add error handling"
```

### Session Management

```bash
# List sessions
opencode session list

# Export a session
opencode export SESSION_ID

# Import a session
opencode import session.json
```

### Web Interface

```bash
# Start the web server
opencode web --port 4096

# Access at http://localhost:4096
```

## Troubleshooting

**`opencode` command not found:**
```bash
export PATH="$HOME/.local/bin:$PATH"
```
