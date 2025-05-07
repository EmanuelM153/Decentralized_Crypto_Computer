{ ... }:

{
  imports = [
    ./shellAliases.nix
    ./defaultPkgs.nix
    ./networking.nix
    ./overlays.nix
    ./users.nix
    ./configuration.nix
    ../../modules/programs
  ];
}
