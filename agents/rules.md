# The rules of the services' work

The infrastructure stack and the test stack beside it (`README.md`): the Compose files that run Redpanda, Redpanda
Console, TimescaleDB, ClickHouse and Redis, published as the flake package `stack`. These are its standing rules, for
an agent of any kind; the format of this file is the kit's (`dev/agents/README.md`, once `make install` has linked it).

## The session

**Read first.**

1. `docs/opening.md`: where the last session stopped, what is open for the owner, the next task, and the files that
   task needs. Read those files, and no others, before starting.
2. `docs/milestones.md`: what the work is for.

Read the others only when the task touches them: `README.md` (the services, the test stack, the ports, a release),
`PRODUCTS.md`, `docs/decisions.md`, the Compose files.

**The rules.**

- **The repository.** This folder is on `main`; its remote is `origin`, `zhifengzhang-sz/qi-v2-services` on GitHub,
  public: nothing private is written into it.

## Every role

- **The stack that runs is left as it is**: nothing starts, stops, recreates or writes to the stack (the Compose
  project `services`) without the owner's say, and nothing runs `down -v` on it or removes a `services_*` volume: its
  volumes hold the data of the projects that use it. A check with the services running runs on the test stack
  (`stack-test`), wiped by `stack-test down -v` when it is done.
- **A service, an image or a port changes only with the owner's say**: a service added or removed, an image's version,
  a host port, a container's, volume's or network's name. Every image is pinned by its exact version, never `latest`,
  and the test stack's are the stack's.
- **The project's secret**: it has no key of its own; the GitHub login that pushes and tags (`~/.ssh/`,
  `~/.config/gh/`) is the owner's. The users and passwords in the Compose files are for development only, and no
  secret.
