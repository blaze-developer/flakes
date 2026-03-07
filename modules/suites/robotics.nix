{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.suites.robotics;

  stable = inputs.stable.legacyPackages."x86_64-linux";
in 
{
  options.suites.robotics.enable = lib.mkEnableOption "Wpilib and Robotics Software Suite";

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.frc-nix.overlays.default ];
    
    environment.systemPackages = with pkgs; [
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

    # AdvantageScope XR
    networking.firewall.allowedTCPPorts = [ 56328 ];
  };
}