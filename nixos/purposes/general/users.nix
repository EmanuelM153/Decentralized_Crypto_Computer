{
  globalVars,
  pkgs,
  lib,
  ...
}:

{
  users = {
    users.root.hashedPassword = lib.mkForce "!";

    users."${globalVars.userName}" = {
      initialHashedPassword = lib.mkDefault "$y$j9T$d9S1lX0.6KOuc4inrbrFz1$49W6CBVQKfi5qJP2Gf4rHG8OaMJEYhTzMWpKCrD42M9";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      home = "/home/${globalVars.userName}";
      shell = pkgs.zsh;
    };
  };
}
