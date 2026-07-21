# Lightbridge Code Intelligence Integration

[Lightbridge Code Intelligence](https://github.com/vymalo/lightbridge-code-intelligence) is an AI-powered code review system that provides deep, repository-aware analysis of pull requests. It combines structural understanding (knowledge graphs) with semantic intelligence (vector embeddings) to deliver comprehensive, hallucination-free code reviews that integrate seamlessly into your development workflow.

## How It Works

```mermaid
flowchart LR
    A[🐙 GitHub / GitLab] --> C[⚙️ Agent Runner]
    C --> D[📦 Clone Repo]
    D --> E[🧠 Build Index]
    E --> F["🤖 AI Agent Loop\n(opencode)"]
    F <--> G[🚦 Quality Gates]
    G --> H[✅ Review Posted]

    subgraph KB[" Knowledge Base "]
      direction LR
      I[🕸️ Graph]
      J[🧠 Embeddings]
    end

    I & J --> F

    style A fill:#f1f5f9,stroke:#cbd5e1,color:#0f172a
    style C fill:#fffbeb,stroke:#d97706,color:#92400e
    style D fill:#f8fafc,stroke:#94a3b8,color:#334155
    style E fill:#fffbeb,stroke:#d97706,color:#92400e
    style F fill:#ede9fe,stroke:#8b5cf6,color:#5b21b6
    style G fill:#cffafe,stroke:#0891b2,color:#0e7490
    style H fill:#d1fae5,stroke:#10b981,color:#065f46
    style I fill:#ede9fe,stroke:#8b5cf6,color:#5b21b6
    style J fill:#cffafe,stroke:#0891b2,color:#0e7490
    style KB fill:#f8fafc,stroke:#e2e8f0
```

### The Review Flow

1. **Trigger** — A GitHub or GitLab event (PR opened, `@mention`, or push to default branch) triggers the system.

2. **Clone & Index** — The system clones the repository and builds two indexes:
   - **Structural Graph** (Neo4j): Shows how code is connected and what calls what
   - **Semantic Embeddings** (pgvector): Shows what code does and implements

3. **AI Agent Loop** — The AI agent explores the codebase using both indexes to understand the full context of the change.

4. **Quality Gates** — Three deterministic gates ensure accuracy:
   - **Coverage Gate**: Ensures every changed file is reviewed
   - **Refute Pass**: Requires AI to challenge its own assumptions
   - **Diff Alignment**: Validates comments anchor to actual changes

5. **Review Posted** — Validated findings are posted to the PR via the single egress point.

## What It Does

## Available Guides

| Guide | What it covers |
|-------|---------------|
| [Overview](00-overview.md) | System architecture, review flow, and quality gates |
| [GitHub Integration](01-github-integration.md) | GitHub App setup and webhook configuration |
| [GitLab Integration](02-gitlab-integration.md) | GitLab webhook setup and configuration |

- **Reviews pull requests automatically** — On every PR opened, it posts a fast, deterministic review; on a maintainer `@mention`, it runs a deep, repo-aware review.
- **Answers questions** — A maintainer can `@mention` the system on an issue for conversational, repo-grounded answers.
- **Indexes repositories** — Once approved, Lightbridge clones the default branch and builds dual indexes that all reviews draw on.

## Two-Tier Review Strategy

Running the full heavyweight loop on every PR is too slow and costly for most signals, so Lightbridge uses a two-tier strategy:

| | **Fast Tier** | **Deep Tier** |
|---|---|---|
| **Trigger** | automatic, on `pull_request opened` | manual, on any `@mention` |
| **Backbone** | **SAST** (deterministic) + lean diff-only LLM pass | full graph + vector retrieval, multi-turn |
| **Retrieval** | none (no retrieval tools) | full |
| **Tools** | small allowlist (`add_review_comment`, `finish`, `abort`) | full surface |
| **Target** | ≲ 2 min | async; long ceiling (2h acceptable) |

The fast tier turns SAST findings plus the raw diff into a human-readable verdict; the deep tier delivers the full repo-aware review.

## Quality Gates

### Coverage Gate
The system enforces that the AI cannot simply skim a large PR and ignore complex files. A plugin intercepts the "finish review" tool and validates that every changed file has been read or commented on.

### Refute Pass
To prevent hallucinations, the system requires the AI to challenge its own assumptions. When proposing a high-severity finding, the AI shifts to a hardened skeptic persona and must search the knowledge base for evidence that its finding is wrong.

### Diff Alignment
The system validates that comments anchor to lines that actually changed. If the AI hallucinates line numbers, the finding is either realigned or downgraded to a general summary comment.

## Core Technologies

- **Syntax Trees**: Hierarchical representation of code structure (AST)
- **Tree-sitter**: Incremental parser for partial/malformed code
- **Knowledge Graph**: Graph database (Neo4j) for structural relationships
- **Vector Embeddings**: Semantic search using high-dimensional vectors

## Getting Started

### Trigger a Review

Simply mention the bot in a PR or issue:

```markdown
@lightbridge-assistant Please review this PR
```

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
@lightbridge-assistant Please review this PR for security issues
```

## Platform Integration

### GitHub

1. **Create GitHub App**
   - Go to [GitHub App Settings](https://github.com/settings/apps)
   - Create new app with webhook URL: `https://your-domain.com/webhook`
   - Repository permissions: Read and write for pull requests
   - Install to your repositories

2. **Configure Webhook**
   - Add webhook with payload URL: `https://your-domain.com/webhook`
   - Secret: Generate a webhook secret
   - Events: `pull_request`, `push`

3. **Access Token**
   - Use GitHub App authentication (not PAT)
   - Minimal permissions: Read and write for pull requests

### GitLab

1. **Create Webhook**
   - Go to [GitLab Settings](https://gitlab.com/-/settings/integrations)
   - Add webhook with URL: `https://your-domain.com/webhook`
   - Secret: Generate a webhook secret
   - Trigger events: Push, Merge request events

2. **Access Token**
   - Use GitLab App authentication (not PAT)
   - Minimal permissions: Read and write for merge requests

## Configuration

### Webhook URL

Configure the webhook URL in your control plane:

```bash
# Environment variable
WEBHOOK_URL=https://your-domain.com/webhook

# Or in config file
webhook:
  url: https://your-domain.com/webhook
  secret: your_webhook_secret
```

### Access Tokens

Use platform-specific authentication:

**GitHub:**
```bash
GITHUB_APP_ID=your_app_id
GITHUB_APP_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\n...\n-----END RSA PRIVATE KEY-----"
GITHUB_WEBHOOK_SECRET=your_webhook_secret
```

**GitLab:**
```bash
GITLAB_APP_ID=your_app_id
GITLAB_APP_SECRET=your_app_secret
GITLAB_WEBHOOK_SECRET=your_webhook_secret
```

### Minimal Permissions

- **GitHub**: Read and write for pull requests only
- **GitLab**: Read and write for merge requests only
- **No repository admin access required**
- **No write access to code files**

## Governance Note

Lightbridge Code Intelligence usage is subject to the [AI Working Agreement](../../12-ai-working-agreement.md). All AI-generated output must be human-verified before merging. Declare AI usage in your PR using the [PR template](../../04-pull-request-template.md).

## Key Features

- **Two-tier review strategy**: Fast automatic reviews (≤2 min) and deep on-demand reviews
- **Dual indexing**: Structural knowledge graph (Neo4j) + semantic embeddings (pgvector)
- **Quality gates**: Coverage, refute pass, and diff alignment to prevent hallucinations
- **Isolated execution**: Each review runs in an ephemeral Kubernetes Job
- **Single egress point**: Only the control plane talks to GitHub/GitLab

## Documentation

For more detailed information about Lightbridge Code Intelligence, see:
- [Lightbridge Code Intelligence Overview](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/lightbridge-code-intelligence-overview.md)
- [Documentation Index](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/INDEX.md)
- [Architecture Overview](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/architecture.md)
- [Review Pipeline](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/review-pipeline.md)