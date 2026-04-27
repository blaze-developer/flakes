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
    ];
  };
}