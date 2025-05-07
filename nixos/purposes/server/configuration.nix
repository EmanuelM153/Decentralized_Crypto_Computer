{ lib, ... }:

{
  services = {
    fail2ban = {
      enable = true;
      maxretry = 5;
    };
    openssh = {
      enable = true;
      settings.PasswordAuthentication = lib.mkDefault false;
    };
  };
}
