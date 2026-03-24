{ lib, config, ... }:
let
  cfg = config.desktop;
in 
{
  imports = [
    ./wm.nix
    ./waybar.nix
    ./wallpaper.nix
    ./theming.nix
    
    ./programs
  ];

  options.desktop = {
    enable = lib.mkEnableOption "desktop environent";
  };

  config = lib.mkIf cfg.enable {
    desktop = {
      wm.enable = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      theming.enable = lib.mkDefault true;

      programs = {
        terminal.enable = lib.mkDefault true;
        browser.enable = lib.mkDefault true;
      };
    };
  };
}