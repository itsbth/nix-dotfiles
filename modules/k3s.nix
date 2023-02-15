{ ... }: {
  # Allow API server
  networking.firewall.allowedTCPPorts = [ 6443 ];

  services.k3s.enable = true;
  services.k3s.role = "server";
}
