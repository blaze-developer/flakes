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
    exec-once = [ "iio-hyprland" ];
  };
}