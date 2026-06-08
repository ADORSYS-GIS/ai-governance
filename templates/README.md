# AI Governance Distribution Kit

This directory holds the **distributable governance kit** for ADORSYS-GIS repositories.
It turns the doctrine published at <https://adorsys-gis.github.io/ai-governance/> into
copy-paste-ready GitHub artifacts and an automated PR gate.

> **AI may accelerate the work, but it must not launder ignorance into polished artifacts.**
> Humans own intent, verification, and consequences.

## What's in the kit

| File | Purpose |
| ---- | ------- |
| `.github/ISSUE_TEMPLATE/epic.yml` | Issue form for **Epics** (from `docs/01`). |
| `.github/ISSUE_TEMPLATE/user-story.yml` | Issue form for **User Stories** (from `docs/02`). |
| `.github/ISSUE_TEMPLATE/dev-ticket.yml` | Issue form for **Development Tickets** (from `docs/03`). |
| `.github/ISSUE_TEMPLATE/config.yml` | Disables blank issues; links the published site, working agreement, and doctrine. |
| `.github/PULL_REQUEST_TEMPLATE.md` | The fill-in PR template (from `docs/04`). |
| `.github/workflows/governance.yml` | Per-repo **caller** workflow that opts a repo into the reusable CI gate. |
| `agent-stanza.md` | The thin governance stanza to embed in `AGENTS.md` / `CLAUDE.md` / `.github/copilot-instructions.md`. |
| `CONTRIBUTING.md` | Short contributor guide pointing at the forms, PR template, and DoR/DoD gates. |

The **reusable enforcement workflow** lives at the repo root, not here:
`.github/workflows/governance-check.yml`.

## How enforcement works

1. A consuming repo adds `.github/workflows/governance.yml` (the caller in this kit).
2. On every pull request (opened / edited / synchronize / reopened), the caller invokes
   `ADORSYS-GIS/ai-governance/.github/workflows/governance-check.yml@main`.
3. The reusable workflow inspects the PR body and **fails** if it is missing any of:
   - an **AI Usage Declaration** section,
   - a **source-of-truth reference** (a URL or a `#123` issue/PR reference),
   - a **Verification** section with evidence (commands, links, or checked boxes).
4. On failure it posts/updates a single **sticky PR comment** listing exactly what's missing.
   It needs `pull-requests: write` (granted in the caller).

The check is lenient about formatting (case-insensitive, tolerant of heading variations)
but firm about presence.

### A note on checkboxes

GitHub issue forms **cannot make an individual checkbox mandatory** — you can require a
`checkboxes` *block* to have at least one option ticked, but not a specific option, and PR
templates have no validation at all. The **CI check is the real gate**: it reads the
submitted PR body and enforces the substantive requirements above. The checkbox blocks in
the forms are declarations and prompts, not the enforcement mechanism.

## How propagation works

- **Issue forms and the PR template** are best distributed once via the org-level
  `ADORSYS-GIS/.github` repository (GitHub applies `.github/ISSUE_TEMPLATE/*` and
  `PROFILE`/community defaults org-wide). Creating that repo is a separate, later step.
- **Per-repo files** that GitHub does *not* inherit org-wide — `AGENTS.md`, `CLAUDE.md`,
  `.github/copilot-instructions.md` (all built from `agent-stanza.md`), the caller
  `.github/workflows/governance.yml`, and `CONTRIBUTING.md` — are pushed to each repo by
  `scripts/sync-templates.zsh`, which opens/refreshes a PR per target repo. The companion
  workflow `.github/workflows/sync-templates.yml` runs that script (it requires a repo
  secret `SYNC_PAT`, since the default `GITHUB_TOKEN` cannot open PRs in other repos).
- Target repos and their **default branches differ**: `adb-mcp-rs` uses `master`; the
  others (`ai-helm`, `converse-frontends`, `lightbridge-authz`, `rag-api`) use `main`.
  The sync script resolves each repo's default branch via `gh repo view` rather than
  assuming.
