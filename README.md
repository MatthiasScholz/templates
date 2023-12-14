# Templates

Collection of templates to get started quickly and in a reproducible way.
Leverages: direnv, nix

Supported:

- go
- terraform

## direnv with nix flakes

``` sh
# Use flake directly - composable
echo "use flake \"github:the-nix-way/dev-templates?dir=flakes/go\"" >> .envrc
direnv allow
```

``` sh
# Use flake as a starting point - tailor
nix flake init -t "github:the-nix-way/dev-templates#go"
direnv allow
```

### Setup

Using Nix Home Manager to install `nix-direnv`

## Develop Templates

``` sh
# With direnv
cd flakes/go

# Without direnv
cd flakes/go
nix develop
```

## References

- [Flakes inspired by](https://github.com/the-nix-way/dev-templates/tree/main)
- [Use direnv with nix](https://determinate.systems/posts/nix-direnv)
