# NOTE: Copy of https://github.com/the-nix-way/dev-templates/blob/main/hashi/flake.nix
{
  description = "A Nix-flake-based development environment for shell scripting";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      # Need go compiler to install some handy tools not available in the nixpkgs
      goVersion = 24;
      overlays = [ (final: prev: { go = prev."go_1_${toString goVersion}"; }) ];
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system: f { pkgs = import nixpkgs { inherit overlays system; }; }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # linting
              shellcheck
              # testing
              bats
              # debugger, in emacs via realgud - darwin unsupported -> use brew
              # bashdb
              # language server
              bash-language-server
              # --- alternatives
              # TODO check if go needs to be installed - if yes: consider moving to golang
              # https://risor.io
              # FIXME does not contain k8s
              risor
              # If shell scripting then with style
              gum
              # Prerequisite to install RSX
              # SEE: https://rubiojr.github.io/rsx/
              go
            ];

            # TODO Check
            # https://github.com/direnv/direnv/issues/73#issuecomment-2478178424
            # NOTE Not supported by direnv!
            # https://discourse.nixos.org/t/how-to-define-alias-in-shellhook/15299
            shellHook = ''
              source <(risor completion bash)
              echo "Setup risor script bundler with external library support: RSX"
              CGO_ENABLED=1 go install --tags fts5,semver github.com/rubiojr/rsx@latest
            '';
          };
        }
      );
    };
}
