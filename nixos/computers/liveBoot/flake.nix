{
  description = "liveBoot Flake";

  inputs = {
    hyprspace.url = "github:hyprspace/hyprspace?ref=master";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:

    let
      system = "x86_64-linux";

      unstable-small-pkgs = import inputs.nixos-unstable-small {
        inherit system;
        config.allowUnfree = true;
      };
      pkgsUnfree = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;

      liveBoot = import ./liveBoot.nix {
        inherit
          pkgsUnfree
          unstable-small-pkgs
          inputs
          system
          ;
      };
    in
    {
      nixosConfigurations.liveBoot = lib.nixosSystem liveBoot;
    };
}
