{
  # The infrastructure stack as a product (README.md): the package stack holds the Compose files and Console's config
  # at their relative paths. bin/stack runs docker compose on the stack's file in the store, and bin/stack-test on the
  # test stack's, which runs beside it and is wiped at will. The common flake, qi-v2, gives the one nixpkgs of every
  # project.
  description = "qi-v2-services: the infrastructure stack (Redpanda, Redpanda Console, TimescaleDB, ClickHouse, Redis)";

  inputs.qi-v2.url = "github:zhifengzhang-sz/qi-v2-nix?dir=qi-v2";
  inputs.nixpkgs.follows = "qi-v2/nixpkgs";

  outputs = { self, nixpkgs, qi-v2 }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      version = "0.3.0";
      src = nixpkgs.lib.fileset.toSource {
        root = ./.;
        fileset = nixpkgs.lib.fileset.unions [
          ./services/docker-compose.yml
          ./services/docker-compose.test.yml
          ./services/config
        ];
      };
      stack = pkgs.runCommand "stack-${version}" {
        inherit version;
        meta.mainProgram = "stack";
      } ''
        mkdir -p $out/bin
        cp -r ${src}/services $out/services
        cat > $out/bin/stack <<EOF
        #!${pkgs.runtimeShell}
        exec docker compose --file $out/services/docker-compose.yml "\$@"
        EOF
        cat > $out/bin/stack-test <<EOF
        #!${pkgs.runtimeShell}
        exec docker compose --file $out/services/docker-compose.test.yml "\$@"
        EOF
        chmod +x $out/bin/stack $out/bin/stack-test
      '';
    in {
      # docker is the one on the path, not one from the store: it is the client of the machine's own engine.
      packages.x86_64-linux.stack = stack;

      # nix run .#stack runs the package's main program; this runs its second, stack-test.
      apps.x86_64-linux.stack-test = {
        type = "app";
        program = "${stack}/bin/stack-test";
        meta.description = "docker compose on the test stack (services-test), wiped with: stack-test down -v";
      };
    };
}
