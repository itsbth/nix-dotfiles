.PHONY: build diff switch diff-and-switch update generate-hardware-configuration print-%

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
	nix --extra-experimental-features 'nix-command flakes' build .#$(TARGET)
	@if [ -d /var/run/current-system ]; \
		then nix store diff-closures /var/run/current-system ./result; \
		else echo "/var/run/current-system missing. first run?"; \
	fi

diff: build
	nix shell 'nixpkgs#nix-diff' -c nix-diff --color=always --skip-already-compared /var/run/current-system ./result | less -R --quit-if-one-screen

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
