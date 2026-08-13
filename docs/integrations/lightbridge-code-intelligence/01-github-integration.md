# Lightbridge Code Intelligence — GitHub Integration

## Setup

### 1. Create GitHub App

1. Go to [GitHub App Settings](https://github.com/settings/apps)
2. Click **New GitHub App**
3. Configure:
   - **Name**: `Lightbridge Code Intelligence`
   - **Description**: AI-powered code review system
   - **Homepage URL**: `https://github.com/vymalo/lightbridge-code-intelligence`
   - **Webhook URL**: `https://your-domain.com/webhook`
   - **Webhook secret**: Generate a webhook secret
   - **Repository permissions**:
     - **Contents**: Read and write
     - **Pull requests**: Read and write
     - **Issues**: Read and write
   - **Events**: `pull_request`, `pull_request_review`, `push`
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
   - **Events**: `pull_request`, `pull_request_review`, `push`
4. Click **Add webhook**

## Configuration

### Environment Variables

```bash
# GitHub App Configuration
GITHUB_APP_ID=your_app_id
GITHUB_APP_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\n...\n-----END RSA PRIVATE KEY-----"
GITHUB_WEBHOOK_SECRET=your_webhook_secret
GITHUB_INSTALLATION_ID=your_installation_id

# Control Plane URL
CONTROL_PLANE_URL=https://your-domain.com
```

### Minimal Permissions

- **Contents**: Read and write (for cloning repo and posting comments)
- **Pull requests**: Read and write (for reading PR data and posting reviews)
- **Issues**: Read and write (for reading issue data and posting answers)
- **No admin access required**
- **No write access to code files**

## Usage

### Automatic Reviews

Lightbridge will automatically post a fast review on every PR opened:

```markdown
# PR opened
# → Fast tier review (≤2 min)
# → Comments on obvious issues
```

### On-Demand Reviews

Trigger a deep review by mentioning the bot:

```markdown
@lightbridge-assistant review
```

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

## Next Steps

- [GitLab Integration](02-gitlab-integration.md)
- [Quality Gates Documentation](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/lightbridge-code-intelligence-overview.md#quality-gates)