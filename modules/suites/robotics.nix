{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.suites.robotics;

  stable = inputs.stable.legacyPackages."x86_64-linux";
in 
{
  options.suites.robotics.enable = lib.mkEnableOption "Wpilib and Robotics Software Suite";

  config = {

    nixpkgs.overlays = [ inputs.frc-nix.overlays.default ];
    
    environment = lib.mkIf cfg.enable {
      systemPackages = with pkgs; [
        advantagescope
        elastic-dashboard
        pathplanner
        wpilib.roborioteamnumbersetter
        wpilib.sysid
        wpilib.wpical
        direnv
      ]++ (with stable; [
        emscripten
      ]);
    };

    # AdvantageScope XR
    networking = lib.mkIf cfg.enable {
      firewall.allowedTCPPorts = [ 56328 ];
    };
  };
}