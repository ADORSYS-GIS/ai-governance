# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is a **documentation repository** holding AI Delivery Governance text material: a set
of copy-paste-ready Scrum artifacts for AI-heavy teams. The throughline of every
document is a discipline layer on top of AI-assisted work — **human accountability,
verification, and intent preservation**. There is no application code, build, or test
tooling; the deliverable is the prose itself.

## Structure

- [`README.md`](README.md) — entry point: the doctrine and an index table linking all 14 artifacts.
- [`docs/`](docs/) — one artifact per file, numbered `00`–`13` to preserve reading order:
  - `00-vocabulary.md` defines the shared terms (intent, source of truth, Definition of Ready/Done, etc.) the other documents lean on.
  - `01`–`03` are work-item templates (epic, user story, dev ticket); `04` is the PR template.
  - `05`–`08` are gates/checklists (AI ticket review, DoR, DoD, refinement).
  - `09`–`11` are ceremony templates (daily scrum, sprint review, retrospective).
  - `12-ai-working-agreement.md` is the cultural artifact; `13-doctrine.md` is the one-page blunt rule.

Each `docs/*.md` file IS the reusable template — content is live Markdown (headings,
checkboxes, tables), not wrapped in an outer code fence, so a file can be copied
straight into a tracker or PR.

## Conventions

- **File names**: `kebab-case`, prefixed with the two-digit artifact number to keep ordering stable.
- **Editing the templates**: preserve the author's wording and the "verbatim" intent — these are governance text, not drafts to paraphrase. Keep the cross-cutting structure consistent across files: `Intent` / `Source of Truth` / `Acceptance Criteria` / `Out of Scope` / `AI Usage Declaration` / `Definition of Ready` / `Definition of Done` recur on purpose. If you add a section to one work-item template, consider whether the siblings need it too.
- **Adding an artifact**: give it the next `NN-` number, render it as live Markdown, and add a row to the README index table.
- The `00-vocabulary.md` terms are load-bearing — if a template uses a new governance term, define it there rather than inline.

<!-- ai-governance:stanza -->
<!-- BEGIN: AI Governance stanza (managed by ADORSYS-GIS/ai-governance) -->
## AI Governance

AI may accelerate the work, but humans own intent, verification, and consequences.
AI output is not truth: review AI-generated code as untrusted, and never submit work you cannot explain.

When opening issues or pull requests in this repo:

- Use the provided **issue forms** (Epic, User Story, Dev Ticket) and the **pull request template** — do not open blank issues/PRs.
- Fill in the **AI Usage Declaration** honestly (what AI was used for, what you verified).
- Include a **source-of-truth link** (a URL or `#123` reference). No source of truth means the work is not ready.
- Provide **verification evidence** (commands, logs, links, or checked verification boxes). No evidence means it is not done.

Source of truth and full doctrine: https://adorsys-gis.github.io/ai-governance/
This stanza is intentionally thin — read the site; do not duplicate the doctrine here.
<!-- END: AI Governance stanza -->
