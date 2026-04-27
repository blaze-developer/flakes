{
  ...
}: {
  imports = [ ../../modules/home ];

  home.stateVersion = "25.11";

  # Bluetooth stuff' 
  wayland.windowManager.hyprland.settings.exec-once = [ "blueman-applet" ];

  desktop = {
    enable = true;
    wm.scaling = 1.67;
  };

  suites.robotics = {
    enable = true;
    systemcore = true;
  };
}
