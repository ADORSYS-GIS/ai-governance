# GitLab Integration

Lightbridge Code Intelligence provides seamless integration with GitLab for repository-aware code reviews.

## Installation

### 1. Create the GitLab Integration

1. Go to [GitLab Settings](https://gitlab.com/-/settings/integrations)
2. Click **New integration**
3. Select **Webhook**
4. Configure the integration:
   - **URL**: `https://your-domain.com/webhook`
   - **Secret**: Generate a webhook secret
   - **Trigger events**: Push, Merge request events
   - **Secret token**: Your webhook secret
5. Click **Add webhook**

### 2. Configure Webhook

1. Go to your project's **Settings** → **Webhooks**
2. Click **Add webhook**
3. Configure:
   - **URL**: `https://your-domain.com/webhook`
   - **Trigger events**: Push, Merge request events
   - **Secret token**: Your webhook secret
   - **SSL verification**: Enabled
4. Click **Add webhook**

### 3. Verify Webhook

1. Make a test push to your repository
2. Go to **Settings** → **Webhooks** → **Show recent deliveries**
3. Verify the webhook received the event
4. Check the response status (should be 200 OK)

## Configuration

### Control Plane Environment Variables

```bash
# GitLab Configuration
GITLAB_URL=https://gitlab.com
GITLAB_APP_ID=your_app_id
GITLAB_APP_SECRET=your_app_secret
GITLAB_WEBHOOK_SECRET=your_webhook_secret

# Control Plane URL
CONTROL_PLANE_URL=https://your-domain.com
```

### Repository Configuration

Create a `.lightbridge.yaml` file in your repository root:

```yaml
# .lightbridge.yaml
review:
  enabled: true
  tier: deep  # 'fast' or 'deep'
  qualityGates:
    coverage: true
    refutePass: true
    diffAlignment: true

integrations:
  gitlab:
    webhookUrl: https://your-domain.com/webhook
    webhookSecret: your_webhook_secret
```

## Usage

### Automatic Reviews

Lightbridge will automatically post a fast review on every merge request opened:

```bash
# Merge request opened
# → Fast tier review (≤2 min)
# → Comments on obvious issues
```

### On-Demand Reviews

Trigger a deep review by mentioning the bot:

```markdown
@lightbridge-bot Please review this merge request
```

### Manual Trigger

You can also trigger reviews manually:

```bash
# Using the CLI
lightbridge-review --repo your-org/your-repo --mr-number 123
```

## Comment Format

### Requesting a Review

```markdown
@lightbridge-bot Please review this merge request
```

### Asking a Question

```markdown
@lightbridge-bot Why does this function handle authentication errors this way?
```

### Requesting Specific Analysis

```markdown
@lightbridge-bot Please review this merge request for security issues
```

## Webhook Events

Lightbridge listens to the following GitLab events:

| Event | Description |
|-------|-------------|
| `Push Hook` | Code pushed to the repository |
| `Merge Request Hook` | Merge request opened, edited, or synchronized |
| `Merge Request Hook` | Merge request approved or unapproved |

## Troubleshooting

### No reviews appearing

1. Check that the webhook is active and receiving events
2. Verify the webhook URL is accessible from GitLab
3. Check the control plane logs for errors
4. Ensure the repository is approved in the Lightbridge admin console

### Reviews not posting comments

1. Verify the control plane has write permissions
2. Check that the merge request is not in draft status
3. Ensure the control plane can reach GitLab API
4. Review the webhook secret configuration

### Rate limiting

GitLab has rate limits for webhook deliveries. If you exceed the limit:
1. Check the GitLab API rate limit headers
2. Consider using GitLab App authentication instead of PAT
3. Implement exponential backoff in your webhook handler

## Security Considerations

- **Webhook Secret**: Always use a webhook secret to verify payloads
- **Secret Token**: Store the GitLab webhook secret securely
- **Trust Boundary**: The control plane owns all credentials; the agent never touches them
- **Repository Visibility**: Only approved repositories can be indexed

## Multi-Project Configuration

Lightbridge supports multi-project configurations:

```yaml
# .lightbridge.yaml
projects:
  - name: frontend
    enabled: true
    tier: deep
  - name: backend
    enabled: true
    tier: fast
```

## Branch Protection

Configure branch protection rules to ensure quality reviews:

```yaml
# GitLab branch protection
- Branch: main
  Merge requests: require approval
  Code coverage: 80%
  Lightbridge review: required
  CI/CD: required
```

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
    Perform a comprehensive review of the entire merge request.
    Consider the impact on the entire codebase.
```

## GitLab CI Integration

Integrate Lightbridge with GitLab CI:

```yaml
# .gitlab-ci.yml
review:
  stage: review
  script:
    - lightbridge-review --repo $CI_PROJECT_PATH --mr-number $CI_MERGE_REQUEST_IID
  only:
    - merge_requests
```

## Next Steps

- [GitHub Integration](01-github-integration.md)
- [Local Setup](03-local-setup.md)
- [Quality Gates Documentation](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/lightbridge-code-intelligence-overview.md#quality-gates)