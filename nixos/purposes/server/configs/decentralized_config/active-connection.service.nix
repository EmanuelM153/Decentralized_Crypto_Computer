{ pkgs, ... }:

let
  awk = "${pkgs.gawk}/bin/gawk";
  ip = "${pkgs.iproute2}/bin/ip";
  batctl = "${pkgs.batctl}/bin/batctl";
in
{
  systemd.services."active-connection" = {
    preStart = ''
      set -ex
      echo "[*] Verificando existencia de la interfaz bat0...";
      for i in {1..10}; do
        ${ip} link show bat0 >/dev/null 2>&1 && break
        echo "[!] bat0 aún no aparece, esperando..."
        sleep 1
      done

      if ! ${ip} link show bat0 >/dev/null 2>&1; then
        echo "[X] La interfaz bat0 no apareció después de 10s"
        exit 1
      fi
    '';

    after = [ "network-decentralized-base.service" ];
    requires = [ "network-decentralized-base.service" ];

    description = "Maintain Active Connection Between Peers";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";

    script = ''
      set -ex
      while true; do
        echo "[*] Escaneando vecinos B.A.T.M.A.N..."

        # Obtener MACs de vecinos actuales
        neighbors=$(${batctl} n | ${awk} '/ ([0-9a-f]{2}:){5}[0-9a-f]{2} / { print $2 }')

        for mac in $neighbors; do
          # Hacer ping y agregar al array
          echo "[*] Haciendo ping a $mac..."
          ${batctl} ping -c 3 "$mac" >/dev/null
        done

        sleep 5
      done
    '';
  };
}
