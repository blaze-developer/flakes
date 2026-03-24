{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.suites.robotics;

  stable = inputs.stable.legacyPackages."x86_64-linux";

  advantagescope-patched = pkgs.advantagescope.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "blaze-developer";
      repo = "AdvantageScope";
      tag = "v26.0.1-blazedev4";
      sha256 = "sha256-oSTfmmSk7tYAzGWGKGcxniTfMZ/ZopRpEsuTYz7Syb8=";
    };
  });
in 
{
  options.suites.robotics.enable = lib.mkEnableOption "Wpilib and Robotics Software Suite";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      advantagescope-patched

      elastic-dashboard
      pathplanner
      choreo
      wpilib.roborioteamnumbersetter
      wpilib.sysid
      wpilib.wpical
      direnv
    ] ++ (with stable; [
      emscripten
    ]);

    # AdvantageScope XR
    networking.firewall.allowedTCPPorts = [ 56328 ];
  };
}
