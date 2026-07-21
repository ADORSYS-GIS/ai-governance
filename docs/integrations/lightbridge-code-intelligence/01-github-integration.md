# GitHub Integration

Lightbridge Code Intelligence provides a GitHub App for seamless integration with your repository's pull request workflow.

## Installation

### 1. Create the GitHub App

1. Go to [GitHub App Settings](https://github.com/settings/apps)
2. Click **New GitHub App**
3. Configure the app:
   - **Name**: `Lightbridge Code Intelligence`
   - **Description**: AI-powered code review system
   - **Homepage URL**: `https://github.com/vymalo/lightbridge-code-intelligence`
   - **Webhook URL**: `https://your-domain.com/webhook` (from your control plane)
   - **Webhook secret**: Generate a secure secret
   - **Repository permissions**:
     - **Contents**: Read and write
     - **Pull requests**: Read and write
     - **Issues**: Read and write
   - **Events**: Enable `pull_request`, `pull_request_review`, `push`
4. Click **Create GitHub App**

### 2. Install the App

1. Go to the **Install** tab of your GitHub App
2. Select the repositories you want to integrate with
3. Click **Install**

### 3. Configure Webhook

1. Go to the **Webhooks** tab of your GitHub App
2. Click **Add webhook**
3. Configure:
   - **Payload URL**: `https://your-domain.com/webhook`
   - **Content type**: `application/json`
   - **Secret**: Your webhook secret
   - **Events**: Select `pull_request`, `pull_request_review`, `push`
4. Click **Add webhook**

## Configuration

### Control Plane Environment Variables

```bash
# GitHub App Configuration
GITHUB_APP_ID=your_app_id
GITHUB_APP_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\n...\n-----END RSA PRIVATE KEY-----"
GITHUB_WEBHOOK_SECRET=your_webhook_secret
GITHUB_INSTALLATION_ID=your_installation_id

# Control Plane URL
CONTROL_PLANE_URL=https://your-domain.com
```

### Verification

1. Open a pull request in your repository
2. Wait a few seconds for the webhook to trigger
3. Check the Lightbridge Code Intelligence logs for the review task
4. Verify that comments are posted to the PR

## Usage

### Automatic Reviews

Lightbridge will automatically post a fast review on every PR opened:

```bash
# PR opened
# → Fast tier review (≤2 min)
# → Comments on obvious issues
```

### On-Demand Reviews

Trigger a deep review by mentioning the bot:

```markdown
@lightbridge-bot Please review this PR
```

### Manual Trigger

You can also trigger reviews manually:

```bash
# Using the CLI
lightbridge-review --repo your-org/your-repo --pr-number 123
```

## Comment Format

### Requesting a Review

```markdown
@lightbridge-bot Please review this PR
```

### Asking a Question

```markdown
@lightbridge-bot Why does this function handle authentication errors this way?
```

### Requesting Specific Analysis

```markdown
@lightbridge-bot Please review this PR for security issues
```

## Webhook Events

Lightbridge listens to the following GitHub events:

| Event | Description |
|-------|-------------|
| `pull_request` | PR opened, edited, or synchronized |
| `pull_request_review` | Review submitted or updated |
| `push` | Code pushed to the repository |

## Troubleshooting

### No reviews appearing

1. Check that the GitHub App is installed to the repository
2. Verify the webhook is active and receiving events
3. Check the control plane logs for errors
4. Ensure the repository is approved in the Lightbridge admin console

### Reviews not posting comments

1. Verify the control plane has write permissions
2. Check that the PR is not in draft status
3. Ensure the control plane can reach GitHub API
4. Review the webhook secret configuration

### Rate limiting

GitHub has rate limits for webhook deliveries. If you exceed the limit:
1. Check the GitHub API rate limit headers
2. Consider using GitHub App authentication instead of PAT
3. Implement exponential backoff in your webhook handler

## Security Considerations

- **Webhook Secret**: Always use a webhook secret to verify payloads
- **Private Key**: Store the GitHub App private key securely
- **Installation Token**: Tokens are short-lived and scoped to the installation
- **Trust Boundary**: The control plane owns all credentials; the agent never touches them

## Advanced Configuration

### Custom Review Tiers

Configure different review behaviors in your deployment:

```yaml
# values.yaml
review:
  fast:
    enabled: true
    timeout: 120  # seconds
    model: "gpt-4o-mini"
  deep:
    enabled: true
    timeout: 7200  # seconds
    model: "claude-3.5-sonnet"
```

### Custom Quality Gates

Modify quality gate behavior:

```yaml
# values.yaml
qualityGates:
  coverage:
    enabled: true
    minCoverage: 100  # percent
  refutePass:
    enabled: true
    minSeverity: 2    # 1=low, 2=medium, 3=high
  diffAlignment:
    enabled: true
    maxLineOffset: 5  # lines
```

### Custom Prompts

Use custom prompts for your organization:

```yaml
# values.yaml
prompts:
  system: |
    You are a senior security engineer at {organization}.
    Focus on security, performance, and architectural integrity.
  fastTier: |
    Perform a quick review of the diff.
    Focus on obvious issues and formatting.
  deepTier: |
    Perform a comprehensive review of the entire PR.
    Consider the impact on the entire codebase.
```

## Next Steps

- [GitLab Integration](02-gitlab-integration.md)
- [Quality Gates Documentation](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/lightbridge-code-intelligence-overview.md#quality-gates)