{
  description = "Go Subscribe";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          options.services.gosubscribe = {
            enable = lib.mkEnableOption "gosubscribe";
            port = lib.mkOption {
              type = lib.types.port;
              default = 3001;
            };
          };

          config = lib.mkIf config.services.gosubscribe.enable {
            systemd.services.gosubscribe = {
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                ExecStart = "${self.packages.${pkgs.system}.default}/bin/gosubscribe";
                Restart = "always";
                DynamicUser = true;
                EnvironmentFile = "/run/secrets/gosubscribe";
              };
              environment = {
                PORT = toString config.services.gosubscribe.port;
              };
            };
          };
        };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [ ./devenv.nix ];
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildGoModule {
            pname = "gosubscribe";
            version = "0.1.0";
            src = ./.;
            vendorHash = "sha256-u6TBAalXCKjhm1Nb3lq8Z698JN3qOEk66mm96TS4HiE=";
            subPackages = [ "cmd/gosubscribe" ];
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/gosubscribe";
        };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
