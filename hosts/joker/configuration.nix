{
  ...
}:
{
  imports = [ ./hardware-configuration.nix ../../configuration.nix ];

  networking.hostName = "joker";

  services.thermald.enable = true;

  drivers = {
    nvidia.enable = true;
    bluetooth.enable = true;
  };

  suites.robotics = {
    enable = true;
    systemcore = true;
  };

  suites.aagl.enable = true;

  system.stateVersion = "25.11";

}
