#!/usr/bin/env zsh
# sync-templates.zsh — propagate the AI Governance kit to ADORSYS-GIS core repos.
#
# Scoped to the named core repos ONLY — nothing is applied org-wide, and no repo is
# ever auto-enrolled. For each target repo it opens (or refreshes) one PR that adds:
#   - .github/ISSUE_TEMPLATE/{epic,user-story,dev-ticket,config}.yml
#   - .github/PULL_REQUEST_TEMPLATE.md
#   - .github/workflows/governance.yml                          (the caller workflow)
#   - AGENTS.md, CLAUDE.md, .github/copilot-instructions.md     (the governance stanza)
#   - CONTRIBUTING.md
#
# Collision-safe (these repos may already have their own files):
#   - Agent files (AGENTS.md/CLAUDE.md/copilot-instructions.md): if the file already
#     exists, the stanza is APPENDED under a marker (never overwritten); else created.
#   - Issue/PR templates and CONTRIBUTING: added only if absent; if the repo already has
#     its own, the script WARNS and leaves it untouched for a human to reconcile.
#   - The caller workflow is governance-owned, so it is written unconditionally.
#
# It resolves each repo's DEFAULT BRANCH via `gh repo view` (adb-mcp-rs is `master`,
# the others `main`) rather than assuming.
#
# DRY-RUN by default; pass --apply to push branches and open PRs. Idempotent: skips a
# repo whose sync branch or PR already exists.
#
# Requires: gh (authenticated with rights on the targets), git.
# This script is for the maintainer to run; it is also invoked by
# .github/workflows/sync-templates.yml with --apply when the SYNC_PAT secret is set.
set -euo pipefail

ORG="ADORSYS-GIS"
TARGET_REPOS=(adb-mcp-rs ai-helm converse-frontends lightbridge-authz rag-api)
SYNC_BRANCH="chore/ai-governance-sync"
STANZA_MARKER="<!-- ai-governance:stanza -->"

APPLY=0
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=1 ;;
    -h|--help)
      print "Usage: sync-templates.zsh [--apply]"
      print "  (no flag)  dry-run: print planned actions only"
      print "  --apply    push branches and open/refresh PRs"
      exit 0
      ;;
    *) print -u2 "Unknown argument: $arg"; exit 2 ;;
  esac
done

# Resolve this kit's directory regardless of where the script is invoked from.
SCRIPT_DIR=${0:A:h}
REPO_ROOT=${SCRIPT_DIR:h}
TEMPLATES_DIR="$REPO_ROOT/templates"
STANZA_FILE="$TEMPLATES_DIR/agent-stanza.md"
CONTRIBUTING_FILE="$TEMPLATES_DIR/CONTRIBUTING.md"
CALLER_WORKFLOW="$TEMPLATES_DIR/.github/workflows/governance.yml"
ISSUE_TEMPLATE_DIR="$TEMPLATES_DIR/.github/ISSUE_TEMPLATE"
PR_TEMPLATE="$TEMPLATES_DIR/.github/PULL_REQUEST_TEMPLATE.md"

for f in "$STANZA_FILE" "$CONTRIBUTING_FILE" "$CALLER_WORKFLOW" "$PR_TEMPLATE"; do
  [[ -f "$f" ]] || { print -u2 "Missing source file: $f"; exit 1; }
done
[[ -d "$ISSUE_TEMPLATE_DIR" ]] || { print -u2 "Missing source dir: $ISSUE_TEMPLATE_DIR"; exit 1; }

if (( APPLY )); then
  print "== sync-templates: APPLY mode (will push branches and open PRs) =="
else
  print "== sync-templates: DRY-RUN (no changes will be made; pass --apply to execute) =="
fi

WORK_ROOT=$(mktemp -d)
trap 'rm -rf "$WORK_ROOT"' EXIT

# Add the stanza to an agent-instruction file: append under a marker if the file exists
# (and the marker isn't already present), else create it.
add_stanza() {
  local dest="$1" label="$2"
  if [[ -f "$dest" ]]; then
    if grep -qF "$STANZA_MARKER" "$dest"; then
      print "    = $label already carries the governance stanza — left as is."
      return
    fi
    {
      print ""
      print "$STANZA_MARKER"
      print "## AI Governance"
      print ""
      cat "$STANZA_FILE"
    } >> "$dest"
    print "    + appended governance stanza to existing $label"
  else
    {
      print "$STANZA_MARKER"
      cat "$STANZA_FILE"
    } > "$dest"
    print "    + created $label"
  fi
}

# Add a template file/dir only if absent; warn + skip on collision.
add_if_absent() {
  local src="$1" dest="$2" label="$3"
  if [[ -e "$dest" ]]; then
    print "    ! $label already exists in repo — skipped (reconcile by hand)."
    return 0
  fi
  cp -R "$src" "$dest"
  print "    + added $label"
}

for repo in "${TARGET_REPOS[@]}"; do
  slug="$ORG/$repo"
  print "\n--- $slug ---"

  # Resolve the default branch (adb-mcp-rs=master, others=main).
  if ! default_branch=$(gh repo view "$slug" --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null); then
    print -u2 "  ! could not query $slug (auth or access?). Skipping."
    continue
  fi
  print "  default branch: $default_branch"

  # Skip if the sync branch already exists remotely (idempotent).
  if gh api "repos/$slug/branches/$SYNC_BRANCH" >/dev/null 2>&1; then
    print "  branch $SYNC_BRANCH already exists upstream — skipping (idempotent)."
    continue
  fi

  # Skip if an open PR from the sync branch already exists.
  existing_pr=$(gh pr list --repo "$slug" --head "$SYNC_BRANCH" --state open --json url --jq '.[0].url' 2>/dev/null || true)
  if [[ -n "$existing_pr" ]]; then
    print "  open PR already exists: $existing_pr — skipping."
    continue
  fi

  if (( ! APPLY )); then
    print "  would: create branch '$SYNC_BRANCH' off '$default_branch' and add:"
    print "         .github/ISSUE_TEMPLATE/* , .github/PULL_REQUEST_TEMPLATE.md ,"
    print "         .github/workflows/governance.yml , CONTRIBUTING.md ,"
    print "         AGENTS.md / CLAUDE.md / .github/copilot-instructions.md (stanza)"
    print "  would: open PR against '$default_branch' (appending stanza to, and skipping, files the repo already has)."
    continue
  fi

  # --- APPLY ---
  clone_dir="$WORK_ROOT/$repo"
  gh repo clone "$slug" "$clone_dir" -- --depth 1 --branch "$default_branch"
  git -C "$clone_dir" checkout -b "$SYNC_BRANCH"

  mkdir -p "$clone_dir/.github/workflows"

  # Governance stanza into the three agent files (append-safe).
  add_stanza "$clone_dir/AGENTS.md" "AGENTS.md"
  add_stanza "$clone_dir/CLAUDE.md" "CLAUDE.md"
  add_stanza "$clone_dir/.github/copilot-instructions.md" ".github/copilot-instructions.md"

  # Caller workflow is governance-owned — write unconditionally.
  cp "$CALLER_WORKFLOW" "$clone_dir/.github/workflows/governance.yml"
  print "    + .github/workflows/governance.yml"

  # Issue forms, PR template, CONTRIBUTING — added only if the repo lacks its own.
  add_if_absent "$ISSUE_TEMPLATE_DIR" "$clone_dir/.github/ISSUE_TEMPLATE" ".github/ISSUE_TEMPLATE/"
  add_if_absent "$PR_TEMPLATE" "$clone_dir/.github/PULL_REQUEST_TEMPLATE.md" ".github/PULL_REQUEST_TEMPLATE.md"
  add_if_absent "$CONTRIBUTING_FILE" "$clone_dir/CONTRIBUTING.md" "CONTRIBUTING.md"

  git -C "$clone_dir" add -A
  if git -C "$clone_dir" diff --cached --quiet; then
    print "  no changes to sync (everything already present) — skipping PR."
    continue
  fi

  git -C "$clone_dir" -c user.name="ai-governance-bot" \
      -c user.email="noreply@adorsys-gis.local" \
      commit -m "chore: adopt AI Governance kit"
  git -C "$clone_dir" push -u origin "$SYNC_BRANCH"

  gh pr create --repo "$slug" \
    --base "$default_branch" \
    --head "$SYNC_BRANCH" \
    --title "chore: adopt AI Governance kit" \
    --body "$(cat <<'PRBODY'
Adopts the ADORSYS-GIS AI Governance kit for this repo.

Adds (only where not already present):
- `.github/ISSUE_TEMPLATE/*` — epic, user-story, and dev-ticket issue forms + chooser config.
- `.github/PULL_REQUEST_TEMPLATE.md` — the governance PR template.
- `.github/workflows/governance.yml` — opts this repo into the reusable PR governance check.
- `CONTRIBUTING.md` — links the forms, PR template, and DoR/DoD gates.

The governance stanza is added to `AGENTS.md`, `CLAUDE.md`, and
`.github/copilot-instructions.md` (appended if the file already exists, never overwritten).

Any template this repo already maintains is left untouched — reconcile those by hand.

Source of truth: https://adorsys-gis.github.io/ai-governance/

Generated by `scripts/sync-templates.zsh` in ADORSYS-GIS/ai-governance.
PRBODY
)"
  print "  PR opened against $default_branch."
done

print "\nDone."
