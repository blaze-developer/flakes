{ lib, config, inputs, pkgs, ... }:
let
  cfg = config.suites.gaming;
in 
{
  imports = [ inputs.aagl.nixosModules.default ];

  options.suites.gaming.enable = lib.mkEnableOption "Games";

  config = lib.mkIf cfg.enable {
    # Honkers Railway Game
    programs.honkers-railway-launcher.enable = true;

    environment.systemPackages = [
      # Switch Emulator
      # (pkgs.ryubing.overrideAttrs (oldAttrs: rec {
      #   version = "1.3.277";
      #   src = pkgs.fetchurl {
      #     url = "https://git.ryujinx.app/projects/Ryubing/archive/Canary-${version}.tar.gz";
      #     hash = "sha256-oPULYKVPvHWtsj92B3fyqiFKy2ieCEUZRbNFsJx1O7Y=";
      #   };
      # }))
      pkgs.ryubing

      pkgs.chiaki-ng
    ];

    # services.udev.extraRules = ''
    #   # PS5 DualSense controller over USB hidraw
    #   KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"

    #   # PS5 DualSense controller over bluetooth hidraw
    #   KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"

    #   # Sony DualSense Edge Wireless-Controller over bluetooth hidraw
    #   KERNEL=="hidraw*", KERNELS=="*054C:0DF2*", MODE="0660", TAG+="uaccess"

    #   # Sony DualSense Edge Wireless-Controller over USB hidraw
    #   KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0df2", MODE="0660", TAG+="uaccess"
    # '';

    # kboot.kernelModules = [ "hid-sony" "hid-playstation" ];
  };
}
