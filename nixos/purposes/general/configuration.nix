{ lib, inputs, ... }:

{
  imports = [
    ./configuration.hm.nix
  ];

  # CVE-2025-32438
  systemd.shutdownRamfs.enable = false;

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };

    grub = {
      enable = true;
      efiSupport = true;
    };
  };

  fonts.fontDir.enable = true;

  services = {
    libinput.enable = true;
    xserver.xkb.options = "ctrl:swapcaps";
  };

  security = {
    sudo.extraConfig = "Defaults   timestamp_timeout = 10";
    tpm2.enable = true;
  };

  nix = {
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
      randomizedDelaySec = "1h";
    };
    gc = {
      randomizedDelaySec = "1h";
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 5d";
    };
    extraOptions = "experimental-features = nix-command flakes";
    channel.enable = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  console = {
    keyMap = lib.mkDefault "us";
    useXkbConfig = true;
  };
}
