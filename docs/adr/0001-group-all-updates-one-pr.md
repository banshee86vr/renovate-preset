# 0001: Group all enabled Renovate updates into one PR

- Status: Accepted
- Date: 2026-09-08

## Context

Repos that extend `github>banshee86vr/renovate-preset` inherited `config:recommended`, which opens one PR per dependency (plus extra monorepo groups). That produced many concurrent PRs. The account wants at most one open Renovate PR per repo, containing every enabled update.

`helm-schema` extends `with-socialgouv.json` instead of this default and stays on the previous grouping behavior.

## Decision

The default preset extends `group:all`, sets `separateMajorMinor: false` and `prConcurrentLimit: 1`, and ignores `group:monorepos` and `group:recommended` so `config:recommended` cannot split the group. Patch-only updates stay disabled.

## Alternatives considered

- Per-repo `packageRules` in every consumer `renovate.json`: duplicates the same rule and drifts when one file is missed.
- `group:allNonMajor` with majors in separate PRs: still more than one PR when a major exists.
- Changing `with-socialgouv.json` as well: would change `helm-schema`, which is explicitly out of scope.

## Consequences

Consumer repos that extend the default preset get one grouped PR after the next Renovate run. Existing per-dependency PRs stay until Renovate supersedes or closes them. `helm-schema` is unchanged. A later `ignorePresets` on a consumer `renovate.json` replaces this preset's ignore list.
