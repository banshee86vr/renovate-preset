#!/usr/bin/env bash
# Enable GitHub "Allow auto-merge" on repositories you administer.
# This is required for:
#   - gh pr merge <PR> --merge --auto   (or --squash --auto / --rebase --auto)
#   - Renovate platform-native automerge
#
# Usage:
#   ./scripts/enable-allow-auto-merge.sh              # all repos owned by banshee86vr (from gh api user/repos)
#   ./scripts/enable-allow-auto-merge.sh owner/repo [more...]
#
# Limitation (GitHub billing): on Free accounts, auto-merge is available for
# public repositories only. For private repos, PATCH succeeds but
# allow_auto_merge stays false unless you use GitHub Team / Enterprise.

set -euo pipefail

patch_repo() {
  local full="$1"
  local after
  if ! after=$(echo '{"allow_auto_merge":true}' | gh api "repos/${full}" -X PATCH --input - -q .allow_auto_merge 2>/dev/null); then
    echo "FAIL ${full} (API error)"
    return
  fi
  if [[ "${after}" == "true" ]]; then
    echo "OK   ${full}"
  else
    echo "SKIP ${full} (still false — often private repo on Free plan; see AUTOMERGE.md)"
  fi
}

if [[ $# -gt 0 ]]; then
  for full in "$@"; do
    patch_repo "${full}"
  done
  exit 0
fi

gh api user/repos --paginate -q '.[] | select(.owner.login=="banshee86vr") | .full_name' | while read -r full; do
  [[ -n "${full}" ]] || continue
  patch_repo "${full}"
done
