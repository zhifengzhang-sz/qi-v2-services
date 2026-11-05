# Qi v2 Services

Infrastructure services for the Qi v2 trading platform.

The product is the package `stack`, a flake package released by the tag `stack-<version>`. It holds the Compose file
and Console's config, and its program runs `docker compose` on that file with the `docker` on your path, so the machine
needs Docker with the Compose plugin.

## Services

- **Redpanda**: Kafka-compatible streaming platform
- **Redpanda Console**: web UI for Redpanda
- **TimescaleDB**: time-series database, which starts empty: a schema belongs to the project that uses it
- **ClickHouse**: column-oriented database for analytics, which starts empty and makes no database: there are only the
  server's own, `default`, `system`, `information_schema` and `INFORMATION_SCHEMA`
- **Redis**: cache

The users and passwords are for development only: TimescaleDB's `postgres`/`password` and ClickHouse's
`default`/`password`, set in the Compose file.

## Ports

| Service | Host port | What |
|---|---|---|
| Redpanda | 19092 | Kafka API |
| Redpanda | 18081 | Schema Registry |
| Redpanda | 18082 | HTTP Proxy |
| Redpanda | 19644 | Admin API |
| Redpanda Console | 8080 | web UI |
| TimescaleDB | 5432 | PostgreSQL |
| ClickHouse | 8123 | HTTP |
| ClickHouse | 9000 | native |
| Redis | 6379 | Redis |

## Quick Start

```bash
# Start all services
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.2.0#stack -- up -d --wait

# View logs
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.2.0#stack -- logs -f

# Stop services
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.2.0#stack -- down
```

## Changes

- **0.2.0**: ClickHouse added, the image `clickhouse/clickhouse-server:26.8.34.13`. 26.8 is the newer of ClickHouse's
  two LTS lines, 26.3 and 26.8, each supported for a year, and 26.8.34.13 is its newest build with a published release.
  It runs on the host ports 8123 (HTTP) and 9000 (native), with the volume `services_clickhouse_data` and the open-file
  limit 262144. It makes no database at start, and its user `default` and password `password` are for development only.
  It is added on the owner's word, so that the platform can save its K-lines to it, before anything uses it.
- **0.1.0**: the first release of the package `stack`. The Compose project is named `services`, so the stack keeps the
  volumes `services_timescaledb_data`, `services_redpanda_data` and `services_redis_data` wherever it runs from.
  TimescaleDB loads no schema on first start, and the old project's `services/database/`, `services/redpanda/` and
  `services/.env.example` are gone.
