Opening for the next session, written 2026-11-21 by the session before (the kit's shared rules: the state of the work
is in git). It says where the work stands, the next task, and what to read.

## Where the work stands

- The product: `stack` 0.3.0, tagged `stack-0.3.0` (`README.md`, `PRODUCTS.md`): the stack (Redpanda, Redpanda
  Console, TimescaleDB, ClickHouse, Redis) and the test stack beside it (`services-test`).
- The project takes the kit's shared rules and `qi-v2-nix`'s `practices.md` (`docs/decisions.md`, 2026-11-21): qi-v2
  and the kit by their release branches; the project's shell (`nix develop`); `make check` (`products-check`, the
  package built, the flake checked); `make install` once on a machine (the kit at `dev/agents`, the pre-commit hook
  that runs `make verify`, then `make agents`); the project's own rules and the roles `checker` and `reviewer`
  (`agents/`); `PRODUCTS.md`; `.reports/`; `docs/`.
- On this machine `make install` linked the kit (kit-0.7.0) at `dev/agents` and set the pre-commit hook, then stopped
  at `make agents`, there being no `agents/`. `agents/` is written now and `kit check` reads it as "spec: 2 roles, 0
  processes, valid"; `make agents` has not run since, so `AGENTS.md`, `CLAUDE.md` and the roles' files are not
  generated yet. `kit products`: "PRODUCTS.md: 1 products, 3 taken, valid". `make check` was not run this session.
- `kit locks` (what `make locks-check` runs) at this session's end: `kit` current (kit-0.7.0), `qi-v2` current
  (qi-v2-1.0.2), `nixpkgs` outdated (locked ac588ef1c9; nixos-26.05 at ab5c18fded), which comes through qi-v2 and is
  updated by qi-v2's next release, by `nix flake update qi-v2`; none updated.
- `main` is `origin/main` (a963498) and the commit of `agents/` and `docs/`: not pushed.

## The next task

Not named yet: the owner's. Before it, the questions under Open below.

## Open, for the owner

- In `docs/decisions.md`, Open: the stack's release branch; the images' pins; the checks of the services running;
  `agents/` in `make verify`.
- `docs/milestones.md` holds the stack's three releases only: what the work is for next is the owner's to state.
- `README.md` names neither `make check` nor `make install`, though the Makefile's first line gives `README.md` as
  where the stack's checks are.
- `README.md`'s Changes, 0.2.0, says ClickHouse is added on the owner's word: the shared rules keep who decided out of
  a document, and `docs/decisions.md` (2026-11-05) records it.
