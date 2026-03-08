{ lib, config, ... }:
let
  cfg = config.drivers.bluetooth;
in
{
  options.drivers.bluetooth = {
    enable = lib.mkEnableOption "bluetooth service";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}