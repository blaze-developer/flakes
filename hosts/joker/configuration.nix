{
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "joker";

  services.thermald.enable = true;

  drivers = {
    nvidia.enable = true;
    bluetooth.enable = true;
  };

  system.stateVersion = "25.11";

}
