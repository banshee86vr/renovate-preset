# 0002: Wait two days before Renovate proposes a release

- Status: Accepted
- Date: 2026-10-15

## Context

pnpm rejects lockfile entries published less than its minimum release age (default 24h, longer when configured). Renovate was opening grouped PRs for releases inside that window. Artifact updates then failed with `ERR_PNPM_MINIMUM_RELEASE_AGE_VIOLATION`, including on krabbx. snorlx already waited two days in its own `renovate.json` (snorlx ADR 0001). Keeping the delay only in some consumers left other pnpm repos exposed.

## Decision

Set `minimumReleaseAge` to `2 days` in `default.json` and `with-socialgouv.json`. Consumers that extended the preset inherit the delay and drop local duplicates.

## Alternatives considered

- Wait exactly one day: a scheduled run can still select a release a few minutes inside pnpm's cutoff when CI evaluates age again at install time.
- Leave the setting only on snorlx: other pnpm apps keep failing the same way.
- Set pnpm `minimumReleaseAge` to 0: removes the supply-chain delay that was protecting installs.

## Consequences

Releases younger than two days do not get a Renovate PR. A fix that must land sooner still needs a `minimumReleaseAgeExclude` entry in the consumer. Dependabot is removed where Renovate is adopted, so the bot-side age policy is Renovate-only.
