{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.suites.robotics;

  stable = inputs.stable.legacyPackages."x86_64-linux";
in 
{
  options.suites.robotics = {
    enable = lib.mkEnableOption "Wpilib and Robotics Software Suite";
    ftc = lib.mkEnableOption "FTC / Android Tooling";
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
      wpilib.firstdriverstation

      advantagescope
      limelight-hardware-manager

    ] ++ (with stable; [
      emscripten
    ]) ++ lib.optionals cfg.ftc [
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
    ];

    # For proper hidraw support with DS
    services.udev.packages = with pkgs; [
      wpilib.firstdriverstation
      limelight-hardware-manager
    ];

    # FIRST DS Watching Workaround
    environment.variables = {
      DOTNET_hostBuilder__reloadConfigOnChange = "false";
    };

    # AdvantageScope XR (CHECK WHICH ONES OF THESE ARE NEEDED AND MAYBE CONTRIBUTE TO FRC-NIX WITH PORT INSTRUCTIONS TO GET THIS RIGHT)
    networking.firewall.allowedTCPPorts = [ 56328 56329 ];

    # Additional: 5810 1735 6767

    # LL Hardware manager discovery
    networking.firewall.allowedUDPPorts = [ 5808 5809 ];
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p udp --sport 5808 -j nixos-fw-accept
    '';

    systemd.tmpfiles.rules = [ "L+ /usr/bin/pkexec - - - - /run/wrappers/bin/pkexec" ];

  };
}
