{
  ...
}: {
  imports = [ ../../modules/home ];

  home.stateVersion = "25.11";

  # Bluetooth stuff' 
  wayland.windowManager.hyprland.settings.exec-once = [ "blueman-applet" ];

  desktop = {
    enable = true;
    wm.display = "eDP-1, 3840x2400@90, 0x0, 1.6";
  };

  suites.robotics.enable = true;
}
