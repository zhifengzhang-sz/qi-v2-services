# qi-v2-services: what it owns, gives and takes

## Responsibility

This repository owns the infrastructure stack: the Compose file that runs Redpanda, Redpanda Console, TimescaleDB and
Redis on one network, the image version each runs, the ports each publishes, the schema TimescaleDB loads on first
start and Console's config. It does not own the code of anything that connects to the stack, the data held in the
stack's volumes, or the types the generated TimescaleDB schema is generated from.

## Products

| Product | What | Form | Version | Release | Doc |
|---|---|---|---|---|---|
| infrastructure stack | the services brought up by `docker compose up -d`: Redpanda, Redpanda Console, TimescaleDB and Redis | file | none | `main` | `services/docker-compose.yml` |

## Takes

| Product | From | Pinned by |
|---|---|---|

This repository has no flake and no lock file, so it has no row, and the images the stack runs are pinned by version in
`services/docker-compose.yml`.
