# OpenCode — VSCode Integration

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

### 3. Install the VS Code Extension

**Automatic:**
- Open the VS Code integrated terminal (Ctrl+`)
- Run: `opencode`
- The extension installs automatically

**Manual:**
- Open Extensions (Ctrl+Shift+X)
- Search: `OpenCode`
- Click Install

## Configuration

Add to your shell profile (`~/.bashrc` or `~/.zshrc`) so VS Code is used as the editor for OpenCode diffs:

```bash
export EDITOR="code --wait"
```

## Usage

### Keyboard Shortcuts

| Action | Windows / Linux | macOS |
|--------|-----------------|-------|
| Open OpenCode | Ctrl+Esc | Cmd+Esc |
| New session | Ctrl+Shift+Esc | Cmd+Shift+Esc |
| File reference | Alt+Ctrl+K | Cmd+Option+K |

### Examples

**Initialize project context:**
```
/init
```

**Ask about a file:**
```
Explain authentication in @src/auth/login.ts
```

**Plan / Build mode:**
1. Press Tab to switch to **Plan**
2. Describe the feature
3. Press Tab to switch to **Build**
4. Type `Go ahead`

## Troubleshooting

**Extension not installing automatically:**
- Run `opencode` inside the integrated terminal
- If prompted, install the `code` command in PATH via the VS Code command palette

**`opencode` command not found:**
```bash
export PATH="$HOME/.local/bin:$PATH"
```
