{ lib, globalVars, ... }:

{
  services.resolved = {
    enable = true;
    domains = [ "~." ];
    dnssec = "true";
    dnsovertls = "true";
    fallbackDns = [ "149.112.112.112:853" ];
    extraConfig = ''
      DNS=9.9.9.9:853
    '';
  };

  networking = {
    hostName = globalVars.hostName;
    useDHCP = lib.mkDefault true;
    enableIPv6 = lib.mkDefault false;

    networkmanager = {
      enable = true;
      dns = lib.mkForce "none";
      wifi.macAddress = "stable-ssid";
      wifi.backend = "iwd";
      ethernet.macAddress = "stable";
      settings.main.systemd-resolved = false;
    };
  };
}
