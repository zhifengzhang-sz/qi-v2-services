{
  # The infrastructure stack as a product (README.md): the package stack holds the Compose file and Console's config
  # at their relative paths, and bin/stack runs docker compose on that file in the store. The common flake, qi-v2,
  # gives the one nixpkgs of every project.
  description = "qi-v2-services: the infrastructure stack (Redpanda, Redpanda Console, TimescaleDB, ClickHouse, Redis)";

  inputs.qi-v2.url = "github:zhifengzhang-sz/qi-v2-nix?dir=qi-v2";
  inputs.nixpkgs.follows = "qi-v2/nixpkgs";

  outputs = { self, nixpkgs, qi-v2 }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      version = "0.2.0";
      src = nixpkgs.lib.fileset.toSource {
        root = ./.;
        fileset = nixpkgs.lib.fileset.unions [ ./services/docker-compose.yml ./services/config ];
      };
    in {
      # docker is the one on the path, not one from the store: it is the client of the machine's own engine.
      packages.x86_64-linux.stack = pkgs.runCommand "stack-${version}" {
        inherit version;
        meta.mainProgram = "stack";
      } ''
        mkdir -p $out/bin
        cp -r ${src}/services $out/services
        cat > $out/bin/stack <<EOF
        #!${pkgs.runtimeShell}
        exec docker compose --file $out/services/docker-compose.yml "\$@"
        EOF
        chmod +x $out/bin/stack
      '';
    };
}
