{ lib, config, ... }:
let
  cfg = config.desktop;
in 
{
  imports = [
    ./terminal.nix
    ./wm.nix
    ./waybar.nix
    ./wallpaper.nix
    ./theming.nix
  ];

  options.desktop = {
    enable = lib.mkEnableOption "desktop environent";
  };

  config = lib.mkIf cfg.enable {
    desktop = {
      wm.enable = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      theming.enable = lib.mkDefault true;
    };
  };
}