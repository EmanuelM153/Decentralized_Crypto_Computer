{ globalVars, ... }:

{
  home-manager.users.${globalVars.userName}.imports = [
    ./hmconf
  ];

  programs.zsh.enable = true;
}
