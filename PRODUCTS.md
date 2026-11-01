# qi-v2-services: what it owns, gives and takes

## Responsibility

This repository owns the infrastructure stack: the Compose file that runs Redpanda, Redpanda Console, TimescaleDB and
Redis on one network, the image version each runs, the ports each publishes and Console's config. It does not own the
code of anything that connects to the stack or the data held in the stack's volumes.

## Products

| Product | What | Form | Version | Release | Doc |
|---|---|---|---|---|---|
| `stack` | the Compose file, Console's config and `bin/stack`, which runs `docker compose` on them: Redpanda, Redpanda Console, TimescaleDB and Redis | flake package | 0.1.0 | tag `stack-<version>` | `README.md` |

## Takes

| Product | From | Pinned by |
|---|---|---|
| `qi-v2` | `qi-v2-nix` | `flake.lock` |
| `nixpkgs` | `qi-v2`, which it follows | `flake.lock` |
