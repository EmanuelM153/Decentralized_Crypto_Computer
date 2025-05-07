{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "wg-ip";
  runtimeInputs = with pkgs; [
    wireguard-tools
    iproute2
    bash
    coreutils-full
  ];
  text =
    (pkgs.writeShellScript "wg-ip" (
      builtins.readFile (
        builtins.fetchurl {
          url = "https://raw.githubusercontent.com/chmduquesne/wg-ip/refs/heads/master/wg-ip";
          sha256 = "sha256:0xkmj0ff22g0af0xlr6fd3slhwwdpvxh9l64k9ya0igizbp82vf3";
        }
      )
    ))
    + " "
    + ''"$@"'';
}
