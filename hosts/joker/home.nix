{
  ...
}: {
  imports = [ ../../home.nix ];

  home.stateVersion = "25.11";

  wayland.windowManager.hyprland.settings.monitor = "eDP-1, preferred, auto, 1.6";

  # Bluetooth stuff
  wayland.windowManager.hyprland.settings.exec-once = [ "blueman-applet" ];
}
