{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # ── Environment ────────────────────────────────────────────────────────────
  env.GOFLAGS = "-tags=dev";

  # ── Packages ───────────────────────────────────────────────────────────────
  packages = with pkgs; [
    just
    air
    gopls
    golangci-lint
    gotools
    go-tools
    delve

    # Database
    postgres_18
    sqlc
    go-migrate
  ];

  # ── Languages ──────────────────────────────────────────────────────────────
  languages.go.enable = true;

  # ── Shell ──────────────────────────────────────────────────────────────────
  enterShell = ''
    echo "  Go Subscribe Development Environment"

    # ── Secrets ──────────────────────────────────────────────────────────────
    [[ -n "$RESEND_API_KEY" ]] \
      && echo "  ✓ RESEND_API_KEY" \
      || echo "  ✗ RESEND_API_KEY missing"

    echo "  just dev    - live reload"
    echo "  just build  - production build"
  '';
}
