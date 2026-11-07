# Qi v2 Services

Infrastructure services for the Qi v2 trading platform.

The product is the package `stack`, a flake package released by the tag `stack-<version>`. It holds the Compose
files of the stack and of the test stack, Console's config and two programs: `stack` runs `docker compose` on the
stack's file and `stack-test` on the test stack's, each with the `docker` on your path, so the machine needs Docker
with the Compose plugin.

## Services

- **Redpanda**: Kafka-compatible streaming platform
- **Redpanda Console**: web UI for Redpanda
- **TimescaleDB**: time-series database, which starts empty: a schema belongs to the project that uses it
- **ClickHouse**: column-oriented database for analytics, which starts empty and makes no database: there are only the
  server's own, `default`, `system`, `information_schema` and `INFORMATION_SCHEMA`
- **Redis**: cache

The users and passwords are for development only: TimescaleDB's `postgres`/`password` and ClickHouse's
`default`/`password`, set in the Compose file.

## Test stack

A test runs on the test stack, never on the stack: some of what a project keeps in the stack (a Kafka topic kept
forever, for one) cannot have a test's writes taken out again. The test stack (`services/docker-compose.test.yml`)
runs beside the stack and touches nothing of it:

- the Compose project `services-test`, its own network `services-test_qitest-network`
- Redpanda, TimescaleDB, ClickHouse and Redpanda Console, each the image the stack pins, with the stack's users and
  passwords, its database `cryptodb` and Console's config; Redis is left out, as no test needs it
- the containers `qitest-redpanda`, `qitest-timescaledb`, `qitest-clickhouse` and `qitest-console`
- the volumes `services-test_redpanda_data`, `services-test_timescaledb_data` and `services-test_clickhouse_data`
- each host port the stack's plus 10000 (the Test host port in Ports), Redpanda's Kafka API advertised at
  `localhost:29092`
- Console with a health check (`/admin/health`), so that `up --wait` waits for every test service to be healthy

Wipe it whenever a test is done: `stack-test down -v` removes its containers, network and volumes, and the next
`stack-test up -d --wait` starts it empty. The stack itself is never brought down with `-v`: its volumes hold the data
of the projects that use it.

## Ports

| Service | Host port | Test host port | What |
|---|---|---|---|
| Redpanda | 19092 | 29092 | Kafka API |
| Redpanda | 18081 | 28081 | Schema Registry |
| Redpanda | 18082 | 28082 | HTTP Proxy |
| Redpanda | 19644 | 29644 | Admin API |
| Redpanda Console | 8080 | 18080 | web UI |
| TimescaleDB | 5432 | 15432 | PostgreSQL |
| ClickHouse | 8123 | 18123 | HTTP |
| ClickHouse | 9000 | 19000 | native |
| Redis | 6379 | none | Redis |

## Quick Start

```bash
# Start all services
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.3.0#stack -- up -d --wait

# View logs
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.3.0#stack -- logs -f

# Stop services (never with -v: the volumes hold the data)
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.3.0#stack -- down

# Start the test stack
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.3.0#stack-test -- up -d --wait

# Wipe the test stack: its containers, network and volumes
nix run github:zhifengzhang-sz/qi-v2-services/stack-0.3.0#stack-test -- down -v
```

## Changes

- **0.3.0**: the test stack added beside the stack, to be wiped at will (Test stack):
  `services/docker-compose.test.yml`, the Compose project `services-test`, with Redpanda, TimescaleDB, ClickHouse and
  Redpanda Console on the images the stack pins, the containers `qitest-*`, the volumes `services-test_*` and each host
  port the stack's plus 10000. The package `stack` gives a second program, `stack-test`, which runs `docker compose` on
  it, and the flake an app of it for `nix run .#stack-test`. The stack's file, services, images, ports and volumes are
  as in 0.2.0.
- **0.2.0**: ClickHouse added, the image `clickhouse/clickhouse-server:26.8.34.13`. 26.8 is the newer of ClickHouse's
  two LTS lines, 26.3 and 26.8, each supported for a year, and 26.8.34.13 is its newest build with a published release.
  It runs on the host ports 8123 (HTTP) and 9000 (native), with the volume `services_clickhouse_data` and the open-file
  limit 262144. It makes no database at start, and its user `default` and password `password` are for development only.
  It is added on the owner's word, so that the platform can save its K-lines to it, before anything uses it.
- **0.1.0**: the first release of the package `stack`. The Compose project is named `services`, so the stack keeps the
  volumes `services_timescaledb_data`, `services_redpanda_data` and `services_redis_data` wherever it runs from.
  TimescaleDB loads no schema on first start, and the old project's `services/database/`, `services/redpanda/` and
  `services/.env.example` are gone.
