{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    eliza
    open-adventure
    man-pages
    haveged
    curl
    gnupg
    file
    nmap
    openssl
    wget
    unzip
  ];

  services.gpm.enable = true;
}
