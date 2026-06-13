# OpenCode — GitHub Actions Integration

This setup lets OpenCode respond to pull requests and issue comments automatically in CI, using the team's OAuth2-secured model endpoint.

## Setup

### 1. Create a Composite Action

Create `.github/actions/opencode-config/action.yaml` in your repository:

```yaml
name: 'Setup OpenCode Config'
inputs:
  opencode-base-url:
    required: true
  oauth2-issuer:
    required: true
  oauth2-client-id:
    required: true
  oauth2-client-secret:
    required: true
  opencode-model:
    required: true
runs:
  using: 'composite'
  steps:
    - name: Create OpenCode config
      shell: bash
      env:
        OPENCODE_BASE_URL: ${{ inputs.opencode-base-url }}
        OAUTH2_ISSUER: ${{ inputs.oauth2-issuer }}
        OAUTH2_CLIENT_ID: ${{ inputs.oauth2-client-id }}
        OAUTH2_CLIENT_SECRET: ${{ inputs.oauth2-client-secret }}
        OPENCODE_MODEL: ${{ inputs.opencode-model }}
      run: |
        mkdir -p ~/.config/opencode
        cat > ~/.config/opencode/opencode.json << EOF
        {
          "plugin": ["@vymalo/opencode-oauth2"],
          "provider": {
            "lightbridge": {
              "npm": "@ai-sdk/openai-compatible",
              "options": {
                "baseURL": "${OPENCODE_BASE_URL}",
                "oauth2": {
                  "issuer": "${OAUTH2_ISSUER}",
                  "clientId": "${OAUTH2_CLIENT_ID}",
                  "clientSecret": "${OAUTH2_CLIENT_SECRET}",
                  "scopes": ["openid"],
                  "authFlow": "client_credentials"
                }
              }
            }
          }
        }
        EOF
```

### 2. Add GitHub Secrets

Add the following secrets to your repository (Settings → Secrets and variables → Actions):

| Secret | Value |
|--------|-------|
| `OPENCODE_BASE_URL` | `https://api.ai.camer.digital/v1` |
| `OAUTH2_ISSUER` | `https://auth.verif.fyi/realms/camer-digital/` |
| `OAUTH2_CLIENT_ID` | Your Keycloak client ID |
| `OAUTH2_CLIENT_SECRET` | Your Keycloak client secret |
| `OPENCODE_MODEL` | `glm-5` (or whichever model you target) |

> **Risk:** if any of these secrets are absent the workflow step will fail. Make sure all five are defined before enabling the workflow.

### 3. Add the Workflow

Create `.github/workflows/opencode.yaml`:

```yaml
name: opencode
on: [pull_request, issue_comment]

jobs:
  opencode:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v6
      - uses: ./.github/actions/opencode-config
        with:
          opencode-base-url: ${{ secrets.OPENCODE_BASE_URL }}
          oauth2-issuer: ${{ secrets.OAUTH2_ISSUER }}
          oauth2-client-id: ${{ secrets.OAUTH2_CLIENT_ID }}
          oauth2-client-secret: ${{ secrets.OAUTH2_CLIENT_SECRET }}
          opencode-model: ${{ secrets.OPENCODE_MODEL }}
      - uses: anomalyco/opencode/github@v1.16.2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          model: lightbridge/${{ secrets.OPENCODE_MODEL }}
```

## How It Works

- Triggered on every pull request and on issue comments
- The composite action writes the OpenCode config with OAuth2 credentials to `~/.config/opencode/opencode.json`
- `anomalyco/opencode/github` runs OpenCode as a GitHub App bot that can read the PR diff, post review comments, and push suggested fixes
- All AI output appears as bot comments; a human reviewer must approve before merging
