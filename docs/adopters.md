# Who uses this

These projects have adopted the AI Delivery Governance kit — the work-item templates, the
PR template, and the advisory [`governance-check`](https://github.com/ADORSYS-GIS/ai-governance/blob/main/.github/workflows/governance-check.yml)
gate pinned to an immutable release SHA. Each repo carries the agent stanza (`CLAUDE.md` /
`AGENTS.md` / Copilot instructions) so humans **and** assistants are held to the same bar:
declared AI usage, a named source of truth, and real verification evidence on every change.

> Adding your repo? Run `scripts/sync-templates.zsh` from this repo, or copy
> [`templates/`](https://github.com/ADORSYS-GIS/ai-governance/tree/main/templates) in by
> hand, then open a PR and add a row below.

## ADORSYS-GIS

| Project | What it is | Stack |
| --- | --- | --- |
| [ai-helm](https://github.com/ADORSYS-GIS/ai-helm) | GitOps source of truth for the internal AI platform | Helm · ArgoCD · Kubernetes |
| [lightbridge-authz](https://github.com/ADORSYS-GIS/lightbridge-authz) | Authorization / API-key & MCP service | Rust |
| [rag-api](https://github.com/ADORSYS-GIS/rag-api) | Retrieval-augmented-generation backend | Rust |
| [adb-mcp-rs](https://github.com/ADORSYS-GIS/adb-mcp-rs) | Model Context Protocol server | Rust |
| [converse-frontends](https://github.com/ADORSYS-GIS/converse-frontends) | Conversational frontends | TypeScript |

## WhyThatFunction

| Project | What it is | Stack |
| --- | --- | --- |
| [home-os](https://github.com/WhyThatFunction/home-os) | Homelab GitOps platform | Talos · ArgoCD · Kubernetes |

## vymalo

| Project | What it is | Stack |
| --- | --- | --- |
| vymalo-shop *(private)* | E-commerce storefront, [shop.vymalo.com](https://shop.vymalo.com) | Next.js · Prisma · Stripe |
| [opencode-oauth2](https://github.com/vymalo/opencode-oauth2) | OpenCode Toolbelt — OAuth2/OIDC auth, model-metadata, rate-limit & browser-automation plugins for OpenCode | TypeScript · OpenCode |
