# The services' agents: its spec

This project's spec of the work agents do on it, in no tool's terms: `rules.md` (the standing rules) and `roles/` (the
roles). The format, and the kit that writes each kind's files from it (Claude Code, Copilot), are the kit's:
`dev/agents/README.md` once installed (`make install`), its source the flake `kit/` of the public repository
`qi-v2-nix`. After a change here: `make agents`.

## Its roles

| Role | For | Writes | Model |
|---|---|---|---|
| [checker](roles/checker.md) | runs the make targets named and reports their lines | none | small |
| [reviewer](roles/reviewer.md) | tries to refute another's work | none | strongest; other when it is the other model |

A developer whose kind has no generator yet takes a role by hand: the role's file and Every role are the brief.
