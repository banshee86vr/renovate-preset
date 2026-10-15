# 0003: GitHub Packages auth via Mend App secret and shared hostRules

- Status: Accepted
- Date: 2026-10-15

## Context

gimmix, mangikarp, and xatux depend on `@banshee86vr/github-device-session` from `npm.pkg.github.com`. Their `renovate.json` files set `hostRules.token` to an empty string. Renovate then sent no Authorization header, artifact updates failed with `ERR_PNPM_FETCH_401`, and grouped PRs shipped without rewriting `pnpm-lock.yaml`. CI failed on `pnpm install --frozen-lockfile`.

Mend-hosted Renovate no longer decrypts secrets embedded in repo config. Secrets must live in App Credentials on developer.mend.io and be referenced as `{{ secrets.NAME }}`.

## Decision

Put a shared `hostRules` entry for `npm.pkg.github.com` in `default.json` and `with-socialgouv.json` with `token: "{{ secrets.GH_PACKAGES_TOKEN }}"`. Upload a classic PAT with `read:packages` once as the org (or per-repo) secret named `GH_PACKAGES_TOKEN` in the Mend Developer Portal. Consumer repos drop empty local `hostRules`.

Actions CI keeps using the separate GitHub Actions secret set by `set-gh-packages-token.sh`; that path is unchanged.

## Alternatives considered

- Mend-encrypted ciphertext inside `renovate.json`: rejected; Mend disabled config-based encryption for hosted apps.
- Leave empty `token: ""` in consumers: overrides useful auth and causes the 401 artifact failures.
- Configure host rules only in the Mend UI: possible, but a shared preset keeps every consumer aligned and reviewable in git.
- Rely on Renovate's automatic GitHub Packages platform token alone: GitHub does not grant GitHub App tokens access to GitHub Packages, so a PAT is still required.

## Consequences

Renovate can resolve and lock `@banshee86vr/*` packages once `GH_PACKAGES_TOKEN` exists in Mend Credentials. Until that secret is uploaded, artifact updates that need the private package still fail. Rotating the PAT means updating the Mend secret (and the Actions secret via the existing script), not editing every consumer config.
