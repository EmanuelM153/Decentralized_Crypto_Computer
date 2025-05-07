{
  lib,
  pkgs,
  config,
  globalVars,
  ...
}:

let
  wg-ip = pkgs.callPackage ./wg-ip.nix { };
in
{
  users.users."${globalVars.userName}".extraGroups = [ "dialout" ];

  networking = {
    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          listenPort = 51820;
          privateKeyFile = "/etc/wireguard/privatekey";
          generatePrivateKeyFile = true;
          peers = [ ];
        };
      };
    };

    dhcpcd = {
      enable = true;
      extraConfig = ''
        nodhcp
        denyinterfaces wlan0 eth0 wg0
        timeout 1
      '';
    };

    firewall = {
      allowedTCPPorts = [
        101
      ];
      allowedUDPPorts = [
        51820
      ];
    };
    networkmanager.enable = lib.mkForce false;
    wireless = {
      enable = lib.mkForce false;
      iwd.enable = lib.mkForce false;
    };
  };

  systemd.network = {
    enable = true;
    netdevs."bat0".enable = false;
    networks = {
      # # Pruebas
      # "eth0" = {
      #   DHCP = "yes";
      #   matchConfig.Name = "eth0";
      #   # networkConfig = {
      #   #   LinkLocalAddressing = "yes";
      #   #   IPv4LLStartAddress = "169.254.1.0/16";
      #   # };
      # };

      "10-wg0" = {
        DHCP = "no";
        matchConfig.Name = "wg0";
        networkConfig = {
          LinkLocalAddressing = "yes";
          IPv4LLStartAddress = "169.254.0.0/16";
        };
      };
      "10-bat0" = {
        DHCP = "no";
        matchConfig.Name = "bat0";
        networkConfig = {
          LinkLocalAddressing = "yes";
          IPv4LLStartAddress = "169.254.1.0/16";
        };
      };
    };
  };

  boot = {
    kernelParams = [ "net.ifnames=0" ];
    extraModulePackages = with config.boot.kernelPackages; [ batman_adv ];
    initrd.kernelModules = [ "batman-adv" ];
  };

  environment.defaultPackages = with pkgs; [
    (python312.withPackages (python-pkgs: [
    ]))
    iw
    wireguard-tools
    alfred
    batctl
    wg-ip
  ];

  services = {
    openssh.settings.PasswordAuthentication = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
      };
    };
  };
}
