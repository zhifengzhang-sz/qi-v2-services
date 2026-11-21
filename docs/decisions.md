# Decisions

The project's decisions, each recorded once (the kit's shared rules: docs are docs, decisions are decisions). A
document states what stands; this file says who decided it, when, and why. An entry is a line or two: the date, who
(the owner, or the session, as a proposal until the owner decides), the decision, its reason, and the documents it
shapes. Nobody is quoted. Decided entries are by date, oldest first; open ones are at the end.

## Decided

<!-- an entry: - **YYYY-MM-DD, the owner.** The decision. Why: the reason. Shapes: `path`, `path`. -->

- **2026-10-28, the owner.** Every image pinned to the exact version the stack runs on, changed one line at a time:
  TimescaleDB 2.30.1-pg17, Redpanda v26.2.6, Console v3.12.0, Redis 8.8.3-alpine. Why: the floating `latest` and
  `latest-pg16` brought up images the data refused (PostgreSQL 16 on 17's files, Redis 7 on 8's). Shapes:
  `services/docker-compose.yml`.
- **2026-10-28, the owner.** Qdrant removed from the stack. Why: nothing uses it. Shapes:
  `services/docker-compose.yml`, `README.md`.
- **2026-11-01, the owner.** The stack is the flake package `stack`, released by the tag `stack-<version>` and pinned
  by a taker's lock, in place of a sibling checkout; `bin/stack` runs `docker compose` with the `docker` on the path.
  Why: a taker pins what it takes by its lock (`practices.md`, 1 and 3); the `docker` on the path is the client of the
  machine's own engine. Shapes: `flake.nix`, `README.md`, `PRODUCTS.md`.
- **2026-11-01, the owner.** The Compose project is named `services`. Why: so the stack keeps its volumes,
  `services_*`, wherever it runs from, the Nix store included. Shapes: `services/docker-compose.yml`.
- **2026-11-01, the owner.** TimescaleDB starts with an empty database and loads no schema; `services/database/`,
  `services/redpanda/` and `services/.env.example` removed. Why: a schema belongs to the project that uses it. Shapes:
  `services/docker-compose.yml`, `README.md`.
- **2026-11-05, the owner.** ClickHouse added, `clickhouse/clickhouse-server:26.8.34.13`, before anything uses it,
  starting with no database of its own, its user `default` and password `password` for development only. Why: so the
  platform can save its K-lines to it; 26.8 is the newer of ClickHouse's two LTS lines and 26.8.34.13 its newest build
  with a published release; without a user and password the image limits `default` to localhost. Shapes:
  `services/docker-compose.yml`, `README.md`, `PRODUCTS.md`.
- **2026-11-07, the owner.** The test stack beside the stack, the Compose project `services-test`: Redpanda,
  TimescaleDB, ClickHouse and Redpanda Console on the stack's images, each host port the stack's plus 10000, wiped at
  will; Redis left out; the stack itself never brought down with `-v`. Why: a test writes nothing to the stack, some
  of whose data (a Kafka topic kept forever) cannot have a test's writes taken out again; no test needs Redis.
  Shapes: `services/docker-compose.test.yml`, `flake.nix`, `README.md`, `PRODUCTS.md`.
- **2026-11-21, the owner.** The project takes the kit's shared rules and `qi-v2-nix`'s `practices.md`: qi-v2 and the
  kit by their release branches; the project's shell; `make check` (`products-check`, then the package built and the
  flake checked, the checks run by hand before); the kit's make targets and the pre-commit hook; `agents/`;
  `PRODUCTS.md`; `.reports/`; `docs/`. Shapes: `flake.nix`, `Makefile`, `.gitignore`, `agents/rules.md`,
  `PRODUCTS.md`.

## Open

- **The stack's release branch** (the session's proposal). The shared rules: a release moves its branch,
  `release/<product>`, to its tag, and a taker follows the branch. `stack`'s release is its tag alone (`stack-0.1.0`
  to `stack-0.3.0`; `origin` has no `release/stack`), and `README.md`'s Quick Start runs the tag. Proposal:
  `release/stack` made at `stack-0.3.0` and moved to each release's tag; the Quick Start runs it, and `PRODUCTS.md`'s
  Release column says so. Shapes: `README.md`, `PRODUCTS.md`.
- **The images' pins** (the session's proposal). `practices.md`, 1: everything from outside is a flake input, pinned
  by `flake.lock`. The stack's images are pinned by their tags in the two Compose files, which `make locks-check` does
  not ask: a newer build is reported by nothing, and a tag pushed again by its publisher goes unseen. Proposal: left
  so, an image moved only on the owner's say and only where the data's major allows it. Shapes:
  `services/docker-compose.yml`, `services/docker-compose.test.yml`, `Makefile`.
- **The checks of the services running** (the session's proposal). `make check` builds the package and checks the
  flake; what the releases 0.2.0 and 0.3.0 checked with the services running (each healthy, written and read, the
  test stack wiped, the stack's containers, volumes and topics as they were) was done by hand and is run by no target.
  Proposal: left by hand, each check listed in its release's commit. Shapes: `Makefile`, `README.md`.
- **`agents/` in `make verify`** (the session's proposal). `kit check` decodes `agents/` and writes nothing; no target
  here runs it, so a broken role shows only at `make agents`. Proposal: a target `agents-check` (`kit check --root
  .`), run by `make verify` where `agents/` is staged, as `qi-v2-contracts` has it. Shapes: `Makefile`.
