# Combined Development Environment

Showing the use of a **devenv** configurations in this
repository to combine the different configurations
to one holistic development environment setup.

This example demonstrates the use case for the modules:

- [terraform](/flakes/terraform)
- [go](/flakes/go)

Supported modules have to have a `devenv.nix`
configuration file. The `flake.nix` is not used.

## Use Case

Having a multiple repositories using the same
development environment setup while maintaining
one place to configure it.

## References

In the context of my goal, commented references.

- [Github Issue: Example, which made me click](https://github.com/cachix/devenv/issues/14#issuecomment-2880235515)
- [devenv input description: With incomplete example](https://devenv.sh/inputs/)
- [devenv composition: With less explicit example](https://devenv.sh/composing-using-imports/)
- [devenv input.<name>.url reference](https://devenv.sh/reference/yaml-options/)
