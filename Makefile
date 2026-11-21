# The stack's checks (README.md), in the shell (nix develop): `make check`. `make install` once on a machine: the
# kit's part, below.
.PHONY: check

# PRODUCTS.md against the project (the kit's), then the package built and the flake checked (no result link written)
check: products-check
	nix build --no-link .#stack
	nix flake check

# The kit's part, as qi-v2-nix's practices.md gives it (section 8).

# the kit at the commit flake.lock names (section 1), read by nix when make install needs it
KIT = $(shell nix eval --raw --impure --expr 'let l = builtins.fromJSON (builtins.readFile ./flake.lock); k = l.nodes.$${l.nodes.$${l.root}.inputs.kit}.locked; in "github:$${k.owner}/$${k.repo}/$${k.rev}?dir=$${k.dir}"')
NEEDKIT = @test -x dev/agents/bin/kit || { echo "$@: no kit at dev/agents: make install"; exit 1; }
# the kit for the checks: the one make install linked, else run from KIT (CI, or a machine before make install)
KITRUN = $(if $(wildcard dev/agents/bin/kit),dev/agents/bin/kit,nix run "$(KIT)" --)

.PHONY: install agents run-start run-check locks-check products-check verify

install: ## the kit at dev/agents, the pre-commit hook that runs make verify, then make agents
	mkdir -p dev && nix build "$(KIT)" -o dev/agents
	hook=$$(git rev-parse --git-path hooks/pre-commit) && printf '#!/bin/sh\nexec make verify\n' > "$$hook" && chmod +x "$$hook"
	$(MAKE) agents

agents: ## each kind's files from agents/ (kit generate)
	$(NEEDKIT)
	dev/agents/bin/kit generate

run-start: ## before a role's run, ROLE=<role> (kit run-start)
	$(NEEDKIT)
	dev/agents/bin/kit run-start --role "$(ROLE)"

run-check: ## after it, ROLE=<role>, FILES=<a,b> for a role that writes them (kit run-check)
	$(NEEDKIT)
	dev/agents/bin/kit run-check --role "$(ROLE)" $(if $(FILES),--files "$(FILES)")

locks-check: ## whether each lock's source has moved past it (kit locks; then the project's own locks)
	$(KITRUN) locks --root .

products-check: ## whether PRODUCTS.md states what the project has (kit products)
	$(KITRUN) products --root .

verify: ## the checks for what is staged, run by the pre-commit hook (then the project's own checks)
	@if git diff --cached --name-only | grep -qE '^(PRODUCTS\.md|[^/]+\.lock)$$'; then $(MAKE) products-check; fi
