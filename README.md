# banshee86vr Renovate presets

Shared Renovate presets for the `banshee86vr` GitHub account. Canonical rollout guide: [AUTOMERGE.md](./AUTOMERGE.md).

To turn on **Allow auto-merge** on every `banshee86vr/*` repo you own (where your GitHub plan allows it), run [`scripts/enable-allow-auto-merge.sh`](./scripts/enable-allow-auto-merge.sh).

## Presets

| Preset | Use |
|--------|-----|
| `github>banshee86vr/renovate-preset` | Resolves to `default.json`: `config:recommended` + PR automerge + `rebaseWhen: behind-base-branch` + **one grouped PR** for all enabled updates (`group:all`, `prConcurrentLimit: 1`) + **no patch-only PRs** (minor/major updates only). See [docs/adr/0001-group-all-updates-one-pr.md](./docs/adr/0001-group-all-updates-one-pr.md). |
| `github>banshee86vr/renovate-preset//with-socialgouv.json` | Same automerge behavior on top of `local>SocialGouv/renovate-config`. |
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
