{ globalVars, ... }:

{
  home-manager = {
    backupFileExtension = "backup";
    users.${globalVars.userName} = {
      nix.gc = {
        randomizedDelaySec = "1h";
        automatic = true;
        frequency = "daily";
        options = "--delete-older-than 5d";
      };

      home = {
        username = globalVars.userName;
        homeDirectory = "/home/${globalVars.userName}";
      };

      programs.home-manager.enable = true;
    };
  };
}
