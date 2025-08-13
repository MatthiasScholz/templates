define flake-update
	$(eval flake=$(1))
	cd flakes/$(flake) && nix flake update
	cd flakes/$(flake) && devenv update || echo "Skipping $(flake)"
endef

upgrade:
	$(call flake-update, aws)
	$(call flake-update, encore)
	$(call flake-update, gcp)
	$(call flake-update, github)
	$(call flake-update, go)
	$(call flake-update, grafana)
	$(call flake-update, mqtt)
	$(call flake-update, opa)
	$(call flake-update, opentofu)
	$(call flake-update, shell)
	$(call flake-update, terraform)
	$(call flake-update, terraform-provider)
	$(call flake-update, tools)
	nix flake update
