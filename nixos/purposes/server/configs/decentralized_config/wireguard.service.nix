{ pkgs, ... }:

let
  awk = "${pkgs.gawk}/bin/gawk";
  cut = "${pkgs.coreutils-full}/bin/cut";
  avahi-publish = "${pkgs.avahi}/bin/avahi-publish";
  ip = "${pkgs.iproute2}/bin/ip";
  wg = "${pkgs.wireguard-tools}/bin/wg";
  hostname = "${pkgs.nettools}/bin/hostname";
  grep = "${pkgs.gnugrep}/bin/grep";
in
{
  systemd.services."wireguard" = {
    preStart = ''
      set -ex
      echo "[*] Verificando existencia de la interfaz wg0...";
      for i in {1..10}; do
        ${ip} link show wg0 >/dev/null 2>&1 && break
        echo "[!] wg0 aún no aparece, esperando..."
        sleep 1
      done

      if ! ${ip} link show wg0 >/dev/null 2>&1; then
        echo "[X] La interfaz wg0 no apareció después de 10s"
        exit 1
      fi

      echo "[*] wg0 detectada, esperando asignación de IP..."
      for i in {1..10}; do
        IP=$(${ip} -4 addr show wg0 | ${awk} '/inet / {print $2}' | ${cut} -d/ -f1)
        echo $IP
        if [ -n "$IP" ]; then echo "[*] IP detectada en wg0: $IP"; exit 0; fi
        sleep 1
      done

      echo "[X] No se detectó IP en wg0 después de 10s"
      exit 1
    '';

    after = [ "network-decentralized-base.service" ];
    requires = [ "network-decentralized-base.service" ];

    description = "Wireguard Announce to Other Peers";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";

    script = ''
      set -ex
      PUBKEY=$(${wg} show wg0 public-key)
      IP=$(${ip} -4 addr show wg0 | ${grep} -oP '(?<=inet\s)\d+(\.\d+){3}')
      HOSTNAME=$(${hostname})
      # Anunciar clave pública y IP como parte de un servicio mDNS
      ${avahi-publish} -s "$HOSTNAME" _wireguard._udp 51820 "pubkey=$PUBKEY" "ip=$IP"
    '';
  };
}
