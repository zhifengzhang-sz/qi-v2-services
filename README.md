# Qi v2 Services

Infrastructure services for the Qi v2 trading platform.

The product is the package `stack`, a flake package released by the tag `stack-<version>`. It holds the Compose file
and Console's config, and its program runs `docker compose` on that file with the `docker` on your path, so the machine
needs Docker with the Compose plugin.

## Services

- **Redpanda**: Kafka-compatible streaming platform
- **Redpanda Console**: web UI for Redpanda
- **TimescaleDB**: time-series database, which starts empty: a schema belongs to the project that uses it
- **Redis**: cache

## Quick Start

```bash
# Start all services
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.1.0#stack -- up -d --wait

# View logs
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.1.0#stack -- logs -f

# Stop services
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.1.0#stack -- down
```

## Changes

- **0.1.0**: the first release of the package `stack`. The Compose project is named `services`, so the stack keeps the
  volumes `services_timescaledb_data`, `services_redpanda_data` and `services_redis_data` wherever it runs from.
  TimescaleDB loads no schema on first start, and the old project's `services/database/`, `services/redpanda/` and
  `services/.env.example` are gone.
