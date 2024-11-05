# NOTE Copy from:https://github.com/the-nix-way/dev-templates/blob/main/go/flake.nix
{
  description = "A Nix-flake-based Go development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      goVersion = 23;
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
              # go (specified by overlay)
              go
              # Reload go on changes
              # https://github.com/bokwoon95/wgo
              wgo

              # goimports, godoc, etc.
              gotools
              gotestsum
              delve
              # Emacs integration
              gopls
              gomodifytags
              gotests
              gore

              # https://github.com/golangci/golangci-lint
              golangci-lint

              # go-template based generator
              gotemplate

              # profiling
              pprof
              graphviz

              # debugging with emacs
              # https://docs.doomemacs.org/latest/modules/tools/debugger/
              lldb
            ];
          };
        }
      );
    };
}
