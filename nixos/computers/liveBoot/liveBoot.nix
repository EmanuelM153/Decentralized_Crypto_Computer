{
  inputs,
  pkgsUnfree,
  unstable-small-pkgs,
  system,
  ...
}:

let
  commonArgs = {
    inherit
      inputs
      globalVars
      unstable-small-pkgs
      system
      ;
  };

  globalVars = {
    userName = "nixos";
    hostName = "ha";
  };
in
{
  inherit system;
  pkgs = pkgsUnfree;

  modules = [
    ../../purposes/server/configs/decentralized_config
    ../../purposes/server
    ./hardware
    ./configuration.nix

    inputs.hyprspace.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = commonArgs;
      };
    }
  ];

  specialArgs = commonArgs;
}
