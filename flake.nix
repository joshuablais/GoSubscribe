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
              # Core
              go
              templ

              # Build
              just
              air

              # Go tooling (the difference between amateur and master)
              gopls
              golangci-lint
              gotools # goimports, etc.
              go-tools # staticcheck
              delve # debugger
            ];

            shellHook = ''
              export GOFLAGS="-tags=dev"
              echo "Go Subscribe Development Environment"
              echo "  just dev    - live reload"
              echo "  just build  - production build"
            '';
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
