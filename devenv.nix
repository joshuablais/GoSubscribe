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
    sqlc
    goose
  ];

  # ── Languages ──────────────────────────────────────────────────────────────
  languages.go = {
    enable = true;
    package = pkgs.go_1_26;
  };

  # ── Database ──────────────────────────────────────────────────────────────
  services.postgres = {
    enable = true;
    package = pkgs.postgresql_18;
    initialDatabases = [ { name = "gosubscribe"; } ];
    listen_addresses = "127.0.0.1";
    initialScript = ''
      CREATE USER joshua;
      GRANT ALL PRIVILEGES ON DATABASE gosubscribe TO joshua;
    '';
  };

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
