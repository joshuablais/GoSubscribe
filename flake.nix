{
  description = "Go Subscribe";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Secret config lives here, inside outputs' let block
      secretsConfig = {
        resend = {
          envVar = "RESEND_API_KEY";
        };
      };

      loadSecretWithConfig = name: cfg: ''
        if [[ -f ./secrets/${name}.age ]]; then
          ${cfg.envVar}=$(age -d -i ~/.config/age/keys.txt ./secrets/${name}.age 2>/dev/null)
          if [[ $? -eq 0 ]]; then
            export ${cfg.envVar}
            echo "  Loaded ${name}   ${cfg.envVar}"
          else
            echo "  Failed to decrypt ${name}"
          fi
        else
          echo "    Secret file ./secrets/${name}.age not found"
        fi
      '';

    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              go
              templ
              just
              air
              gopls
              golangci-lint
              gotools
              go-tools
              delve
              age # add this — you need it for secret decryption
            ];

            shellHook = ''
              export GOFLAGS="-tags=dev"
              echo "Go Subscribe Development Environment"

              # Load all secrets on shell entry
              ${loadSecretWithConfig "resend" secretsConfig.resend}

              echo "  just dev    - live reload"
              echo "  just build  - production build"
            '';
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
