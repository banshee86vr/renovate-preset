# Upload `GH_PACKAGES_TOKEN` for Renovate

The shared preset references `{{ secrets.GH_PACKAGES_TOKEN }}` for `npm.pkg.github.com`. Mend-hosted Renovate only resolves that from App Credentials, not from GitHub Actions secrets and not from encrypted blobs in `renovate.json`.

## Steps

1. Create or reuse a classic PAT with `read:packages` (same token class as Actions `GH_PACKAGES_TOKEN`).
2. Sign in at https://developer.mend.io with a GitHub account that can admin the `banshee86vr` installation.
3. Open Credentials for the account or installation that owns the consumer repos.
4. Add secret name `GH_PACKAGES_TOKEN`, paste the plaintext PAT, save.
5. Confirm a Renovate run on gimmix (or mangikarp / xatux) updates `pnpm-lock.yaml` without `renovate/artifacts` 401 errors.

Rotate by replacing the Mend secret value. Keep Actions in sync with `../../set-gh-packages-token.sh` when the PAT itself changes.
