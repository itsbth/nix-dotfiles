{ pkgs, ... }:
{
  # Common Darwin configuration shared between all macOS hosts
  
  # TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # GPG agent configuration
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}