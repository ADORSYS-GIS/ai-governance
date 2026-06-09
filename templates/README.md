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
   `ADORSYS-GIS/ai-governance/.github/workflows/governance-check.yml@v1.0.0` — pinned to an
   immutable release tag (not `@main`) so upstream changes never run here unreviewed.
3. The reusable workflow inspects the PR body and **fails** if it is missing any of:
   - an **AI Usage Declaration** section with a **checked AI-usage option**,
   - a **source-of-truth reference** (a URL or a `#123` ref) in the **intent area** — an
     evidence-only or boilerplate governance link does not count,
   - a **Verification** section with evidence (commands, links, or checked boxes).
4. On failure it posts/updates a single **sticky PR comment** listing exactly what's missing.
   It needs `pull-requests: write` (granted in the caller).

The check is lenient about formatting (case-insensitive, tolerant of heading variations)
but firm about presence.

### A note on checkboxes

On the issue forms, the **AI Usage Declaration** is a `required` multi-select **dropdown**,
so a real choice (one or more categories, or "Not used") must be made before submission —
GitHub cannot require "at least one of N" checkboxes, so a dropdown is used instead. The
**Human Verification** block keeps a `required: true` accountability checkbox. PR templates
have no validation at all, so the **CI check remains the substantive gate** for pull requests.
Required text fields use `placeholder:` (grey hints), never `value:` (pre-filled content), so
a required field is empty until the author actually writes something.

## How propagation works

Distribution is **scoped to the named core repos only** — nothing is applied org-wide,
and no repo is ever auto-enrolled. (We deliberately do *not* use an org-level
`ADORSYS-GIS/.github` repository: its community-health defaults would apply to *every*
repo in the org, including ones that aren't ready to adopt the governance gate.)
Targets are full `owner/repo` slugs, so the set can span organisations — the core fleet
includes `WhyThatFunction/home-os` alongside the `ADORSYS-GIS` repos.

- **Everything** in this kit — the issue forms, the PR template, the caller
  `.github/workflows/governance.yml`, `CONTRIBUTING.md`, and the governance stanza
  (`AGENTS.md` / `CLAUDE.md` / `.github/copilot-instructions.md`, built from
  `agent-stanza.md`) — is committed **directly into each target repo** by
  `scripts/sync-templates.zsh`, which opens one PR per repo (idempotent — an existing sync
  branch/PR is left untouched, not auto-updated; see the script header for the update path).
  The companion workflow `.github/workflows/sync-templates.yml` runs that script (it requires
  a repo secret `SYNC_PAT`, since the default `GITHUB_TOKEN` cannot open PRs in other repos).
- The script is **collision-safe**: the stanza is *appended* to an existing
  `AGENTS.md`/`CLAUDE.md`/`copilot-instructions.md` (never overwritten); issue forms are
  copied **individually** (a repo with unrelated templates still gets the ones it lacks);
  and any PR template / `CONTRIBUTING.md` / issue form the repo already owns is left
  untouched and flagged for manual reconciliation. Missing `epic` / `user-story` / `ticket`
  labels are created (forms only apply labels that already exist).
- The generated adoption-PR body itself satisfies the governance gate (it declares AI usage
  and includes a Verification section), so later sync PRs pass the check in already-governed
  repos.
- Target repos and their **default branches differ**: `ADORSYS-GIS/adb-mcp-rs` uses `master`;
  the others (`ai-helm`, `converse-frontends`, `lightbridge-authz`, `rag-api`, and
  `WhyThatFunction/home-os`) use `main`. The sync script resolves each repo's default branch
  via `gh repo view` rather than assuming.
- To enroll a future repo, add its full `owner/repo` slug to `TARGET_REPOS` in the sync
  script and re-run — enrollment is always explicit, and cross-org targets are supported.
