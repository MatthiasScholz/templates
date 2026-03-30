{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  languages.go = {
    enable = true;
    package = pkgs.go_1_25;
  };

  # https://devenv.sh/packages/
  packages = [
    # Development helper (including Emacs support)
    # .goimports, godoc, ...
    pkgs.gotools
    pkgs.gomodifytags
    pkgs.gotemplate
    pkgs.gopls
    # .REPL for Emacs
    # ..https://github.com/x-motemen/gore
    pkgs.gore
    # .Reload go on changes
    # ..https://github.com/bokwoon95/wgo
    pkgs.wgo
    # Static Code Analysis
    pkgs.golangci-lint
    # Testing
    pkgs.gotests
    pkgs.gotestsum
    # Debugger
    # .debugging with emacs:
    # ..https://docs.doomemacs.org/latest/modules/tools/debugger/
    pkgs.delve
    pkgs.lldb
    # Profiling
    pkgs.pprof
    pkgs.graphviz
  ];

  # Module introduction
  enterShell = ''
    echo INFO :: go environment setup
    echo "go version $(go version)"

    # HACK symlink delve to ~/go/bin
    #      because emacs dap-mode does not recognize
    #      direnv installed delve and defaults to $HOME/go/bin"
    mkdir -p ~/go/bin
    ln -sf ${pkgs.delve}/bin/dlv ~/go/bin/dlv
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    go version | grep --color=auto "${pkgs.go.version}"
  '';
}
