{
  ...
}: {
  imports = [ ../home.nix ];

  wayland.windowManager.hyprland.settings.monitor = "eDP-1, preferred, auto, 1.6";
}