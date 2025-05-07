{ ... }:

{
  imports = [
    ./network_decentralized_base.nix
    ./wireguard.service.nix
    ./wireguard_discover.service.nix
    ./configuration.nix
    ./active-connection.service.nix
  ];
}
