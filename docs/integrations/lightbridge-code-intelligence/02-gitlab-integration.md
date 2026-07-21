# Lightbridge Code Intelligence — GitLab Integration

## Setup

### 1. Create GitLab Integration

1. Go to [GitLab Settings](https://gitlab.com/-/settings/integrations)
2. Click **New integration**
3. Select **Webhook**
4. Configure:
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

### Environment Variables

```bash
# GitLab Configuration
GITLAB_URL=https://gitlab.com
GITLAB_APP_ID=your_app_id
GITLAB_APP_SECRET=your_app_secret
GITLAB_WEBHOOK_SECRET=your_webhook_secret

# Control Plane URL
CONTROL_PLANE_URL=https://your-domain.com
```

### Minimal Permissions

- **Repository**: Read and write (for cloning repo and posting comments)
- **Merge requests**: Read and write (for reading MR data and posting reviews)
- **Issues**: Read and write (for reading issue data and posting answers)
- **No admin access required**
- **No write access to code files**

## Usage

### Automatic Reviews

Lightbridge will automatically post a fast review on every merge request opened:

```markdown
# Merge request opened
# → Fast tier review (≤2 min)
# → Comments on obvious issues
```

### On-Demand Reviews

Trigger a deep review by mentioning the bot:

```markdown
@lightbridge-assistant Please review this merge request
```

### Asking Questions

Get repo-grounded answers to questions:

```markdown
@lightbridge-assistant Why does this function handle authentication errors this way?
```

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

## Next Steps

- [GitHub Integration](01-github-integration.md)
- [Quality Gates Documentation](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/lightbridge-code-intelligence-overview.md#quality-gates)