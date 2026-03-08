{
  ...
}: {
  imports = [ ../../modules/home ];

  home.stateVersion = "25.11";

  # Bluetooth stuff
  wayland.windowManager.hyprland.settings.exec-once = [ "blueman-applet" ];

  desktop = {
    enable = true;
    wm.display = ", preferred, auto, 1.6";
  };
}