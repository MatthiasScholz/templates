{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # Make the port configurable on a use basis, but provide a default
  # NOTE: everyone should us a different port to avoid collision when running multiple opencode instances
  # Try to get ports from your shell; if empty string, use default
  env.OPENCODE_PORT = "53053";
  env.OPENCODE_PROFILE = "default";
  env.OPENCODE_CONFIG_DIR = "~/.config/opencode/profiles/$OPENCODE_PROFILE`";

  # https://devenv.sh/packages/
  packages = [
    pkgs.bun
    # npx
    pkgs.nodejs_22
  ];

  # https://devenv.sh/processes/
  processes.opencode-web = {
    exec = ''
      opencode web --port $OPENCODE_PORT
    '';
  };
  scripts.opencode-attach.exec = ''
    opencode attach http://localhost:$OPENCODE_PORT
  '';

  # TODO Configure the port or understand how multiple opencode instances are handled
  processes.opencode-dashboard.exec = ''
    bunx oh-my-opencode-dashboard@latest
  '';

  # https://devenv.sh/scripts/
  scripts.opencode-setup-plugin.exec = ''
    bunx oh-my-opencode install
  '';

  scripts.opencode-web-open.exec = ''
    open http://localhost:$OPENCODE_PORT
  '';

  scripts.opencode-dashboard-open.exec = ''
    open http://localhost:$OPENCODE_DASHBOARD_PORT
  '';

  # Skills
  # SEE: https://skills.sh
  scripts.skill-list.exec = ''
    npx skills list
  '';
  scripts.skill-search.exec = ''
    npx skills find $@
  '';
  scripts.skill-install.exec = ''
    $@ --agent opencode
  '';
  scripts.skill-update-check.exec = ''
    npx skills check
  '';
  scripts.skill-update.exec = ''
    npx skills update
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    echo INFO :: opencode environment setup
    echo "opencode version $(opencode --version)"
    echo opencode port: $OPENCODE_PORT
    echo opencode dashboard port: $OPENCODE_DASHBOARD_PORT
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    opencode --version | grep --color=auto "${pkgs.opencode.version}"
  '';

  # See full reference at https://devenv.sh/reference/options/
}
