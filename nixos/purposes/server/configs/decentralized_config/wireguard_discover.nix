{ pkgs, ... }:

let
  awk = "${pkgs.gawk}/bin/gawk";
  avahi-browse = "${pkgs.avahi}/bin/avahi-browse";
  ip = "${pkgs.iproute2}/bin/ip";
  wg = "${pkgs.wireguard-tools}/bin/wg";
  cut = "${pkgs.coreutils-full}/bin/cut";
  grep = "${pkgs.gnugrep}/bin/grep";
in
{
  systemd.services."wireguard-discover" = {
    preStart = ''
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

    description = "Wireguard Discover and Add Other Peers";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";

    script = ''
        set -ex
        WG_INTERFACE="wg0"
        PORT=51820

        # Obtener IP local actual asignada a wg0
        MY_IP=$(${ip} -4 addr show "$WG_INTERFACE" | ${grep} -oP '(?<=inet\s)\d+(\.\d+){3}')
        # Obtener clave pública local
        MY_PUBKEY=$(${wg} show wg0 public-key)

        echo "[*] IP propia: $MY_IP"
        echo "[*] Clave pública propia: $MY_PUBKEY"

        # Ejecutar avahi-browse y procesar cada línea con IP y pubkey
        while true; do
          ${avahi-browse} -rpt _wireguard._udp | while read -r line; do
            if [[ "$line" == *"pubkey="* && "$line" == *"ip="* ]]; then

              # Extraer valores
              PEER_IP=$(echo "$line" | ${grep} -oP 'ip=\K[^"]+')
              HOST_IP=$(echo "$line" | ${cut} -d ';' -f 8)
              PEER_PUBKEY=$(echo "$line" | ${grep} -oP 'pubkey=\K[^"]+')

              # Ignorar a uno mismo por IP o clave pública
              if [[ "$PEER_IP" == "$MY_IP" || "$PEER_PUBKEY" == "$MY_PUBKEY" ]]; then
                echo "[!] Ignorado: peer con misma IP o clave propia ($PEER_IP)"
                continue
              fi

              # Evitar duplicados
              if ${wg} show "$WG_INTERFACE" peers | ${grep} -q "$PEER_PUBKEY"; then
                echo "[*] Peer ya agregado: $PEER_IP"
                continue
              fi

              # Agregar el peer a la configuración de wg
              echo "[+] Agregando peer $PEER_IP ($HOST_IP)"
              ${wg} set "$WG_INTERFACE" peer "$PEER_PUBKEY" allowed-ips "$PEER_IP/32" endpoint "$HOST_IP:$PORT"
            fi
          done
        sleep 5
      done
    '';
  };
}
