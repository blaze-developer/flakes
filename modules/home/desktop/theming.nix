{ lib, config, ... }:
let 
  cfg = config.desktop.theming;
in
{
  options.desktop.theming = {
    enable = lib.mkEnableOption "theming through pywal";
  };

  config = lib.mkIf cfg.enable {
    programs.pywal.enable = true;

    home.file.".config/wal/templates/colors-hyprland.conf".source = ./templates/colors-hyprland.conf;

    programs.bash.initExtra = ''
      (cat ~/.cache/wal/sequences &)
    '';

    programs.bash.enable = true; # Enable bash to have bashrc work

    desktop.wallpaper.enable = lib.mkDefault true; # Enable the wallpaper

    wayland.windowManager.hyprland.settings = {
      source = "~/.cache/wal/colors-hyprland.conf";

      general = {
        "col.active_border" = "$color6 $color7 45deg";
        "col.inactive_border" = "$background";
      };
    };
  };
}
