{ ... }:

{
  imports = [
    ./network_decentralized_base.nix
    ./wireguard.service.nix
    ./wireguard_discover.nix
    ./configuration.nix
  ];
}
