{
  config,
  lib,
  pkgs,
  globalVars,
  ...
}:

let
  cfg = config.customizable;
in
{
  options.customizable = {
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/Bogota";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
    };

    terminusFont = lib.mkOption {
      type = lib.types.str;
      default = "ter-u32n";
    };

    initPass = lib.mkOption {
      default = "qwerty";
      type = lib.types.str;
    };
  };

  config = {
    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = cfg.locale;
    console.font = "${pkgs.terminus_font}/share/consolefonts/${cfg.terminusFont}.psf.gz";
    users.users."${globalVars.userName}".initialPassword = cfg.initPass;
  };
}
