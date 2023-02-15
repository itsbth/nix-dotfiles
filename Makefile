.PHONY: build diff switch diff-and-switch update print-%

HOSTNAME := $(shell hostname)
OS := $(shell uname -s)
# nixosConfigrations.<hostname>.conifg.system.build.toplevel on NixOS, darwinConfigurations.<hostname>.system on Darwin
TARGET := $(if $(filter Darwin,$(OS)),darwinConfigurations.$(HOSTNAME).system,nixosConfigurations.$(HOSTNAME).config.system.build.toplevel)
REBUILD := $(if $(filter Darwin,$(OS)),darwin-rebuild,nixos-rebuild)

diff-and-switch: build
	$(MAKE) -o build diff
	@echo "Switch to new derivation? [y/N] " && read ans && [ $${ans:-N} = y ]
	$(MAKE) -o build switch

build:
	nix build .#$(TARGET)

diff: build
	nix-diff /var/run/current-system ./result

switch: build
	result/sw/bin/$(REBUILD) switch --flake .#

update:
	nix flake update

generate-hardware-configuration: hosts/$(HOSTNAME)/hardware-configuration.nix

hosts/$(HOSTNAME)/hardware-configuration.nix: | hosts/$(HOSTNAME)
	@if nixos-generate-config --show-hardware-config > $@; \
	then echo "Hardware configuration updated"; \
	else echo "nixos-generate-config failed; try running the command again with sudo"; false; \
	fi

print-%:
	@echo $*=$($*)
