# OpenCode — IntelliJ Integration

OpenCode has no native IntelliJ plugin; it runs inside IntelliJ's built-in terminal, which gives you a split-pane AI assistant alongside your editor.

## Setup

### 1. Install OpenCode CLI

```bash
npm install -g opencode-ai
```

### 2. Authenticate

```bash
opencode auth login https://ai.camer.digital/opencode
```

Browser opens for authentication. Login, return to terminal, select model.

### 3. Open in the IntelliJ Terminal

- Open IntelliJ
- Open the terminal: Alt+F12
- Navigate to your project: `cd /path/to/project`
- Run: `opencode`

## Configuration

Set IntelliJ as the editor for OpenCode diffs. Add to your shell profile (`~/.bashrc` or `~/.zshrc`):

**macOS:**
```bash
export EDITOR="idea --wait"
```

**Linux:**
```bash
export EDITOR="/opt/idea/bin/idea.sh --wait"
```

**Windows (PowerShell):**
```powershell
$env:EDITOR = "idea64 --wait"
```

## Usage

### Basic Commands

**Initialize project context:**
```
/init
```

**Reference a file:**
```
Explain @src/main/kotlin/UserService.kt
```

**Run a shell command from within OpenCode:**
```
!./gradlew test
```

### Split-Pane Workflow

1. Open terminal (Alt+F12)
2. Right-click the terminal tab
3. Select **Split Right**
4. Run OpenCode in one pane, keep your shell in the other

## Troubleshooting

**`opencode` command not found:**
```bash
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```
