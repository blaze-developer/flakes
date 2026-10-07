{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.suites.robotics;

  stable = inputs.stable.legacyPackages."x86_64-linux";

  advantagescope-2027 = inputs.frc-nix-2027.legacyPackages."x86_64-linux".advantagescope;

  elastic-2027 = pkgs.elastic-dashboard.overrideAttrs (oldAttrs: rec {
    version = "2027.0.0-alpha6";

    src = pkgs.fetchurl {
      url = "https://github.com/Gold872/elastic_dashboard/releases/download/v${version}/Elastic-Linux.zip";
      hash = "sha256-YQO3D+F4jO5JKZFvj4uZh+/jz0aarxIvR87PuD9iZ8E=";
    };

    desktopItems = [
      (pkgs.makeDesktopItem {
        desktopName = "Elastic 2027 Alpha";
        name = "elastic-dashboard-2027";
        exec = "elastic_dashboard";
        icon = "elastic-dashboard";
        comment = "A simple and modern dashboard for FRC";
        categories = [ "Development" ];
        keywords = [ "FRC" "Dashboard" ];
      })
    ];
  });
in 
{
  options.suites.robotics = {
    enable = lib.mkEnableOption "Wpilib and Robotics Software Suite";
    ftc = lib.mkEnableOption "FTC / Android Tooling";

    systemcore = lib.mkEnableOption "2027 Systemcore Alpha Testing";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = with inputs; [
      frc-nix.overlays.default
    ];

    environment.systemPackages = with pkgs; [
      pathplanner
      choreo
      wpilib.roborioteamnumbersetter
      wpilib.sysid
      wpilib.wpical
      direnv

      advantagescope

      # Android / FTC Tooling
      android-tools

      # Arduino
      arduino-cli
      arduino

      (pkgs.symlinkJoin {
          name = "android-studio-wayland";
          paths = [ pkgs.android-studio ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/android-studio \
              --add-flags "-Dawt.toolkit.name=WLToolkit"
          '';
        })
    ] ++ (with stable; [
      emscripten
    ]) ++ lib.optionals cfg.systemcore [
      advantagescope-2027
      elastic-2027
    ];

    # AdvantageScope XR
    networking.firewall.allowedTCPPorts = [ 56328 56329 5810 1735 6767 ];
  };
}
