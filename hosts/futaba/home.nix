{
  pkgs,
  ...
}: {
  imports = [ ../../home.nix ];

  home.stateVersion = "25.05";

  home.pkgs = with pkgs; [
    iio-hyprland
  ];

  wayland.windowManager.hyprland.settings = { 
    monitor = "eDP-1, preferred, auto, 1.2";

    exec-once = [ "iio-hyprland" ];
  };
}