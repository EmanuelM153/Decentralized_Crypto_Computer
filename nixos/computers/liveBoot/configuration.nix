{
  config,
  modulesPath,
  lib,
  globalVars,
  ...
}:
{

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs.hostPlatform = config.system;

  boot.loader.grub.enable = lib.mkForce false;

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  system.stateVersion = "25.05";

  home-manager.users.${globalVars.userName}.home.stateVersion = "25.05";
}
