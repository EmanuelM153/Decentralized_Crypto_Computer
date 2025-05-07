{
  pkgs,
  config,
  lib,
  ...
}:

let
  wg-ip = pkgs.callPackage ./wg-ip.nix { };
  cfg = config.adhocNet;
  rfkill = "${pkgs.util-linux}/bin/rfkill";
  ip = "${pkgs.iproute2}/bin/ip";
  iw = "${pkgs.iw}/bin/iw";
  batctl = "${pkgs.batctl}/bin/batctl";
in
{
  options.adhocNet = {
    ssid = lib.mkOption {
      type = lib.types.str;
      default = "rubik";
    };
    psk = lib.mkOption {
      type = lib.types.str;
      default = "colombiaTierraQuerida";
    };
    apMac = lib.mkOption {
      type = lib.types.str;
      default = "02:12:34:56:78:9A";
    };
    frequency = lib.mkOption {
      type = lib.types.str;
      default = "2412";
    };
  };

  config = {
    systemd.services."network-decentralized-base" = {
      after = [ "network.target" ];
      before = [ "network-online.target" ];
      description = "Configuracion Base Red Decentralizada";
      wantedBy = [ "multi-user.target" ];
      wants = [ "dhcpd.service" ];

      script = ''
        set -ex
        ${rfkill} unblock wifi
        ${iw} wlan0 set type ibss
        ${ip} link set up mtu 1532 dev wlan0
        ${iw} dev wlan0 ibss join ${cfg.ssid} ${cfg.frequency} HT20 fixed-freq ${cfg.apMac}

        ${batctl} if add wlan0
        ${ip} link set up dev bat0
        ${batctl} gw_mode client 20
        sleep 3
        ${wg-ip}/bin/wg-ip apply -4 dev wg0
      '';
    };
  };
}
