{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.suites.robotics;

  stable = inputs.stable.legacyPackages."x86_64-linux";

  advantagescope-patched = pkgs.advantagescope.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "blaze-developer";
      repo = "AdvantageScope";
      tag = "v2026.0.1-blazedev5";
      sha256 = "sha256-jlQbeW7a2J2zRKio7c7OCA2/eaLh3lZm3JDZuJjpko4=";
    };
  });

  advantagescope-2027 =
    let
      desktopItem = pkgs.makeDesktopItem {
        desktopName = "AdvantageScope 2027 Alpha";
        name = "advantagescope-2027";
        exec = "advantagescope-2027";
        icon = "advantagescope";
        categories = [ "Robotics" "Development" ];
        keywords = [ "FRC" "Data" "Visualisation" ];
      };

      version = "27.0.0-alpha-4";
    in
    pkgs.appimageTools.wrapType2 {
      pname = "advantagescope-2027";
      version = "27.0.0-alpha-4";
      src = pkgs.fetchurl {
        url = "https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-x64-v${version}.AppImage";
        hash = "sha256-HLIL4uB2nt/oS+BrIsXxJjacnQKnEsEhG3QM9HAhrBg=";
      };
      extraInstallCommands = ''
        install -Dm444 ${desktopItem}/share/applications/*.desktop \
          $out/share/applications/advantagescope-2027.desktop
        install -Dm444 ${pkgs.advantagescope}/share/pixmaps/advantagescope.png \
          $out/share/pixmaps/advantagescope.png
      '';
    };

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
    environment.systemPackages = with pkgs; [
      pathplanner
      choreo
      wpilib.roborioteamnumbersetter
      wpilib.sysid
      wpilib.wpical
      direnv

      advantagescope-patched
      elastic-dashboard

      # Android / FTC Tooling
      android-tools

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
    networking.firewall.allowedTCPPorts = [ 56328 ];
  };
}
