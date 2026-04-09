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
in 
{
  options.suites.robotics = {
    enable = lib.mkEnableOption "Wpilib and Robotics Software Suite";
    ftc = lib.mkEnableOption "FTC / Android Tooling";
  };

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
    ]);

    # AdvantageScope XR
    networking.firewall.allowedTCPPorts = [ 56328 ];
  };

  # config = lib.mkMerge [
  #   lib.mkIf cfg.enable {
  #     environment.systemPackages = with pkgs; [
  #       advantagescope-patched

  #       elastic-dashboard
  #       pathplanner
  #       choreo
  #       wpilib.roborioteamnumbersetter
  #       wpilib.sysid
  #       wpilib.wpical
  #       direnv

  #       android-tools
  #     ] ++ (with stable; [
  #       emscripten
  #     ]);

  #     # AdvantageScope XR
  #     networking.firewall.allowedTCPPorts = [ 56328 ];
  #   }
  #   lib.mkIf cfg.ftc {
  #     environment.systemPackages = [
  #       (pkgs.symlinkJoin {
  #         name = "android-studio-wayland";
  #         paths = [ pkgs.android-studio ];
  #         buildInputs = [ pkgs.makeWrapper ];
  #         postBuild = ''
  #           wrapProgram $out/bin/android-studio \
  #             --add-flags "-Dawt.toolkit.name=WLToolkit"
  #         '';
  #       })
  #     ];
  #   }
  # ];
}
