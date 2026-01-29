{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = [ pkgs.bun ];

  # https://devenv.sh/processes/
  processes.opencode-web.exec = ''
    opencode web --port 53053
  '';
  scripts.opencode-attach.exec = ''
    opencode attach http://localhost:53053
  '';

  processes.opencode-dashboard.exec = ''
    bunx oh-my-opencode-dashboard@latest
  '';

  # https://devenv.sh/scripts/
  scripts.opencode-setup-plugin.exec = ''
    bunx oh-my-opencode install
  '';

  scripts.opencode-web-open.exec = ''
    open http://localhost:53053
  '';

  scripts.opencode-dashboard-open.exec = ''
    open http://localhost:51234
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    echo INFO :: opencode environment setup
    echo "opencode version $(opencode --version)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    opencode --version | grep --color=auto "${pkgs.opencode.version}"
  '';

  # See full reference at https://devenv.sh/reference/options/
}
