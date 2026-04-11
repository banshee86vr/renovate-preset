# Renovate automerge for `banshee86vr`

This repository hosts the shared Renovate presets (`default.json`, `with-socialgouv.json`, `no-tests.json`). Consumer repos use `github>banshee86vr/renovate-preset` in `extends`.

## 1. Repo audit (local workspace layout)

Branch protection and required reviews live in GitHub settings, not in git.

### Repos with `pull_request` workflows (rely on green checks; do **not** use `no-tests`)

| Directory | Notes |
|-----------|--------|
| `charts/` | Many PR workflows (incl. `pull_request_target` on some jobs). |
| `homelab/` | `validate.yml` on PR. |
| `krabbx/` | CI + security + lockfile sync for Renovate. |
| `snorlx/` | Same pattern as krabbx. |
| `neon/` | CI + security on PR (`release.yml` is push-only). |
| `nexus-k8s-operator/` | `ci.yml` on PR. |
| `postgrest-gcp-vm-poc/` | CI + CodeQL on PR. |
| `torneovieoppeano_site/` | `ci.yml` on PR. |

### Repos without PR-triggered CI (use `no-tests.json` in `renovate.json`)

These workflows are **push/tag only** (or no first-party PR checks), so Renovate would wait forever for status checks unless `ignoreTests` is set.

| Directory | Notes |
|-----------|--------|
| `helm-schema/` | `tests.yaml` runs on **push** only → PRs get no CI unless you add `pull_request`. |
| `docs-generator-template/` | `release.yml` only. |
| `ephemeral-test-environment/` | `release.yml` only. |
| `helm-charts/` | `release.yml` only. |
| `mono-repo-test/` | `release-please.yaml` on push only. |
| `notion-activity-report/` | `release.yml` only. |
| `repo-template/` | `release.yml` only. |

### Workspace folders without `.github/workflows`

Not listed here; add `renovate.json` when those repos enable Renovate. Optional: add `pull_request` CI and then use the default preset **without** `no-tests.json`.

## 2. GitHub settings (every repo that should automerge)

Do this on **github.com** (repeat per repo or use org rulesets where applicable).

1. **Allow auto-merge** (required for `gh pr merge … --auto` and Renovate platform merge)  
   Repository **Settings → General → Pull Requests** → enable **Allow auto-merge**.

   **GitHub CLI:** when branch protection blocks an immediate merge, use **`--auto`** so the PR is **queued** and merges as soon as checks and reviews are satisfied:

   ```bash
   gh pr merge <number> --squash --auto --delete-branch
   # or --merge --auto / --rebase --auto
   ```

   **Bulk (repos you own):** from this repo, run [`scripts/enable-allow-auto-merge.sh`](./scripts/enable-allow-auto-merge.sh) to `PATCH` each `banshee86vr/*` repository with `allow_auto_merge: true`.

   **Billing note:** On the **Free** plan, GitHub only supports auto-merge for **public** repositories. For **private** repos, the API may leave `allow_auto_merge` as `false` until you use **GitHub Team** / **Enterprise** (or make the repository public). The script reports `SKIP` in that case.

2. **Required status checks** (repos with PR CI)  
   Branch protection / rulesets for the default branch: enable **Require status checks to pass** and **select the exact check names** your workflows publish (e.g. job names from Actions).  
   If you enable “require checks” but list none, GitHub may not block on failures — see [Renovate automerge docs](https://docs.renovatebot.com/key-concepts/automerge/).

3. **Required reviews**  
   If **Require pull request reviews** is on, either:
   - Add **Allow specified actors to bypass required pull requests** for `renovate[bot]`, or  
   - Install a Renovate approval helper (e.g. [renovate-approve](https://github.com/apps/renovate-approve)) so automerge is not blocked.

4. **CODEOWNERS**  
   If reviews are required from code owners, ensure Renovate can still merge (bypass or bot approval), or automerge will stall.

5. **Renovate app**  
   Ensure the Mend Renovate app (or your bot) has permission to **merge** and that the target branch allows it.

## 3. Consumer `renovate.json`

- **With PR CI:** `extends: ["github>banshee86vr/renovate-preset"]`
- **No PR checks:** add `github>banshee86vr/renovate-preset//no-tests.json` as a second preset.
- **helm-schema:** `with-socialgouv.json` + `no-tests.json`.

To **opt out** of automerge in one repo:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["github>banshee86vr/renovate-preset"],
  "packageRules": [{ "matchPackageNames": ["*"], "automerge": false }]
}
```

## 4. Pilot rollout

1. **Pilot A — repo with PR CI** (e.g. `krabbx`): Confirm the PR body shows **Automerge: Enabled** and merge happens only after required checks succeed.
2. **Pilot B — no PR checks** (e.g. `helm-schema`): Confirm the PR automerges without waiting for missing checks.

If automerge stalls, check: auto-merge disabled, missing required check names, review rules, or Renovate run delay (see [Renovate docs](https://docs.renovatebot.com/key-concepts/automerge/)).

## 5. Rebasing / conflicts

`rebaseWhen: behind-base-branch` in the preset keeps branches current. Conflicts still require a new Renovate run or manual fix; Renovate will recreate/rebase when it can.
