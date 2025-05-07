{ lib, config, ... }:

let
  cfg = config.git;
in
{
  options.git.enable = lib.mkEnableOption "Enable Git";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      difftastic.enable = true;
    };
  };
}
