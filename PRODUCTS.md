# qi-v2-services: what it owns, gives and takes

## Responsibility

This repository owns the infrastructure stack: the Compose file that runs Redpanda, Redpanda Console, TimescaleDB,
ClickHouse and Redis on one network, the image version each runs, the ports each publishes and Console's config. It
owns the test stack beside it too: the Compose file that runs Redpanda, Redpanda Console, TimescaleDB and ClickHouse on
the same images, on ports and volumes of its own, to be wiped whenever a test is done. It does not own the code of
anything that connects to either stack or the data held in their volumes.

## Products

| Product | What | Form | Version | Release | Doc |
|---|---|---|---|---|---|
| `stack` | the Compose files, Console's config, `bin/stack`, which runs `docker compose` on the stack's file (Redpanda, Redpanda Console, TimescaleDB, ClickHouse and Redis), and `bin/stack-test`, which runs it on the test stack's (Redpanda, Redpanda Console, TimescaleDB and ClickHouse, the project `services-test`) | flake package | 0.3.0 | tag `stack-<version>` | `README.md` |

## Takes

| Product | From | Pinned by |
|---|---|---|
| `qi-v2` | `qi-v2-nix` | `flake.lock` |
| `nixpkgs` | `qi-v2`, which it follows | `flake.lock` |
