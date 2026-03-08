{ lib, config, inputs, ... }:
let
  cfg = config.desktop.wallpaper;
in
{
  options.desktop.wallpaper = {
    enable = lib.mkEnableOption "wallpaper daemon";
  };

  config = lib.mkIf cfg.enable {
    services.swww = {
      enable = true;
      package = inputs.stable.swww;
    };
  };
}