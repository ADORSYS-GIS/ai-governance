# Local Setup

Get Lightbridge Code Intelligence running locally for development and testing.

## Prerequisites

- **Node.js**: v18 or higher
- **pnpm**: v8 or higher
- **Docker**: v20 or higher
- **Docker Compose**: v2 or higher
- **Rust**: v1.70 or higher (for control plane development)
- **Neo4j**: v5.0 or higher (for knowledge graph)
- **PostgreSQL**: v14 or higher (for task queue and embeddings)
- **pgvector**: Extension for PostgreSQL

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/vymalo/lightbridge-code-intelligence.git
cd lightbridge-code-intelligence
```

### 2. Install Dependencies

```bash
# Install pnpm if not already installed
npm install -g pnpm

# Install project dependencies
pnpm install
```

### 3. Start Services with Docker Compose

```bash
# Start all services
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f
```

### 4. Configure Environment Variables

Create a `.env` file in the root directory:

```bash
# Control Plane
CONTROL_PLANE_URL=http://localhost:3000
CONTROL_PLANE_PORT=3000

# Database
DATABASE_URL=postgresql://lightbridge:lightbridge@localhost:5432/lightbridge
POSTGRES_USER=lightbridge
POSTGRES_PASSWORD=lightbridge
POSTGRES_DB=lightbridge

# Neo4j
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=lightbridge

# Embeddings
OPENAI_API_KEY=your_openai_api_key
OPENAI_BASE_URL=https://api.openai.com/v1

# GitHub App (optional for local testing)
GITHUB_APP_ID=your_app_id
GITHUB_APP_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\n...\n-----END RSA PRIVATE KEY-----"
GITHUB_WEBHOOK_SECRET=your_webhook_secret
GITHUB_INSTALLATION_ID=your_installation_id

# GitLab (optional for local testing)
GITLAB_URL=https://gitlab.com
GITLAB_APP_ID=your_app_id
GITLAB_APP_SECRET=your_app_secret
GITLAB_WEBHOOK_SECRET=your_webhook_secret
```

### 5. Run the Control Plane

```bash
# Development mode
pnpm dev

# Production mode
pnpm build
pnpm start
```

### 6. Access the Web Console

Open your browser and navigate to:
- **Control Plane**: http://localhost:3000
- **Neo4j Browser**: http://localhost:7474 (username: neo4j, password: lightbridge)
- **PostgreSQL**: localhost:5432

## Development Setup

### Control Plane Development

```bash
# Navigate to control plane
cd services/control-plane

# Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Install dependencies
cargo install cargo-watch
cargo install cargo-edit

# Run development server
cargo watch -x run

# Run tests
cargo test

# Run linter
cargo clippy
```

### Agent Runner Development

```bash
# Navigate to agent-runner
cd services/agent-runner

# Install dependencies
pnpm install

# Run development server
pnpm dev

# Run tests
pnpm test

# Run linter
pnpm lint
```

### Frontend Development

```bash
# Navigate to apps/web
cd apps/web

# Install dependencies
pnpm install

# Run development server
pnpm dev

# Run tests
pnpm test

# Run linter
pnpm lint
```

## Configuration Files

### Control Plane

```yaml
# services/control-plane/config.yaml
control_plane:
  port: 3000
  host: 0.0.0.0

database:
  url: postgresql://lightbridge:lightbridge@localhost:5432/lightbridge
  pool_size: 10

neo4j:
  uri: bolt://localhost:7687
  user: neo4j
  password: lightbridge

github:
  app_id: your_app_id
  private_key: "-----BEGIN RSA PRIVATE KEY-----\n...\n-----END RSA PRIVATE KEY-----"
  webhook_secret: your_webhook_secret
  installation_id: your_installation_id
```

### Agent Runner

```yaml
# services/agent-runner/config.yaml
agent_runner:
  image: lightbridge/agent-runner:latest
  replicas: 1

review:
  fast:
    enabled: true
    timeout: 120
    model: "gpt-4o-mini"
  deep:
    enabled: true
    timeout: 7200
    model: "claude-3.5-sonnet"

quality_gates:
  coverage:
    enabled: true
    min_coverage: 100
  refute_pass:
    enabled: true
    min_severity: 2
  diff_alignment:
    enabled: true
    max_line_offset: 5
```

## Testing

### Run All Tests

```bash
# Run all tests
pnpm test

# Run tests with coverage
pnpm test:coverage

# Run tests in watch mode
pnpm test:watch
```

### Run Specific Tests

```bash
# Run control plane tests
cd services/control-plane && cargo test

# Run agent runner tests
cd services/agent-runner && pnpm test

# Run web tests
cd apps/web && pnpm test
```

### Integration Tests

```bash
# Run integration tests
pnpm test:integration

# Run integration tests with Docker
pnpm test:integration:docker
```

## Troubleshooting

### Services not starting

1. Check Docker is running: `docker ps`
2. Check port availability: `lsof -i :3000`
3. Review logs: `docker-compose logs`

### Database connection issues

1. Verify PostgreSQL is running: `docker-compose ps postgres`
2. Check database credentials in `.env`
3. Verify pgvector extension is installed

### Neo4j connection issues

1. Verify Neo4j is running: `docker-compose ps neo4j`
2. Check Neo4j credentials in `.env`
3. Verify Neo4j is accessible: `curl http://localhost:7474`

### Embedding issues

1. Verify OpenAI API key is set
2. Check API key has sufficient credits
3. Verify OpenAI base URL is correct

### Webhook not receiving events

1. Verify webhook URL is accessible from GitHub/GitLab
2. Check webhook secret matches
3. Review control plane logs for errors
4. Verify GitHub/GitLab integration is enabled

## Clean Up

### Stop All Services

```bash
docker-compose down
```

### Remove All Data

```bash
# Stop and remove containers
docker-compose down -v

# Remove volumes
docker volume rm lightbridge-code-intelligence_postgres_data
docker volume rm lightbridge-code-intelligence_neo4j_data

# Remove images
docker rmi lightbridge-control-plane lightbridge-agent-runner
```

## Production Deployment

For production deployment, see [Kubernetes Deployment](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/kubernetes-deployment.md).

## Next Steps

- [GitHub Integration](01-github-integration.md)
- [GitLab Integration](02-gitlab-integration.md)
- [Architecture Overview](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/architecture.md)
- [Review Pipeline](https://github.com/vymalo/lightbridge-code-intelligence/blob/main/docs/review-pipeline.md)