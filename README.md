# banshee86vr Renovate presets

Shared Renovate presets for the `banshee86vr` GitHub account. Canonical rollout guide: [AUTOMERGE.md](./AUTOMERGE.md).

To turn on **Allow auto-merge** on every `banshee86vr/*` repo you own (where your GitHub plan allows it), run [`scripts/enable-allow-auto-merge.sh`](./scripts/enable-allow-auto-merge.sh).

## Presets

| Preset | Use |
|--------|-----|
| `github>banshee86vr/renovate-preset` | Resolves to `default.json`: `config:recommended` + PR automerge + `rebaseWhen: behind-base-branch` + **one grouped PR** for all enabled updates (`group:all`, `prConcurrentLimit: 1`) + **no patch-only PRs** (minor/major updates only) + `minimumReleaseAge: 2 days` + GitHub Packages `hostRules` via Mend App secret. See [docs/adr/0001-group-all-updates-one-pr.md](./docs/adr/0001-group-all-updates-one-pr.md), [docs/adr/0002-minimum-release-age-two-days.md](./docs/adr/0002-minimum-release-age-two-days.md), [docs/adr/0003-github-packages-hostrules-in-preset.md](./docs/adr/0003-github-packages-hostrules-in-preset.md). |
| `github>banshee86vr/renovate-preset//with-socialgouv.json` | Same automerge, age, and Packages hostRules on top of `local>SocialGouv/renovate-config`. |
| `github>banshee86vr/renovate-preset//no-tests.json` | Sets `ignoreTests: true` so Renovate can automerge when no checks run on PRs. Combine with one of the above. |

## Consumer examples

**Repo with PR CI** (wait for green checks):

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["github>banshee86vr/renovate-preset"]
}
```

**Repo with push-only / no PR checks** (e.g. release workflows only):

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>banshee86vr/renovate-preset",
    "github>banshee86vr/renovate-preset//no-tests.json"
  ]
}
```

**helm-schema** (SocialGouv base + no PR checks today):

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>banshee86vr/renovate-preset//with-socialgouv.json",
    "github>banshee86vr/renovate-preset//no-tests.json"
  ]
}
```

## Prerequisites

See [AUTOMERGE.md](./AUTOMERGE.md) for GitHub settings (auto-merge, required checks, reviews / bypass).

### GitHub Packages (`@banshee86vr/*`)

Mend-hosted Renovate does **not** read encrypted secrets from `renovate.json`. The preset references `{{ secrets.GH_PACKAGES_TOKEN }}` for `npm.pkg.github.com`.

1. Create a classic PAT with `read:packages` (same class of token as Actions).
2. Open [developer.mend.io](https://developer.mend.io), open the `banshee86vr` org or user Credentials settings.
3. Add secret name `GH_PACKAGES_TOKEN` with the plaintext PAT. Prefer org/user scope so every consumer inherits it.
4. Do not put the plaintext or an empty `token: ""` in any consumer `renovate.json`.

GitHub Actions still uses the separate Actions secret. Set or rotate that with [`../set-gh-packages-token.sh`](../set-gh-packages-token.sh) from the banshee86vr Projects tree. Step-by-step for the Mend secret: [`scripts/remind-mend-gh-packages-secret.md`](./scripts/remind-mend-gh-packages-secret.md).
