{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.suites.robotics;

  stable = inputs.stable.legacyPackages."x86_64-linux";

  frc-nix-2027 = inputs.frc-nix-2027.legacyPackages."x86_64-linux";
  limelight-hardware-manager = (pkgs.extend inputs.frc-nix-ll.overlays.default).limelight-hardware-manager;
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
      frc-nix-2027.advantagescope
      limelight-hardware-manager

      pkgs.wpilib.firstdriverstation
    ];

    # For proper hidraw support with DS
    services.udev.packages = lib.optionals cfg.systemcore [
      pkgs.wpilib.firstdriverstation
      limelight-hardware-manager

      (pkgs.writeTextDir "lib/udev/rules.d/70-limelight-flash.rules" ''
        SUBSYSTEM=="block", ATTRS{idVendor}=="0a5c", ATTRS{idProduct}=="0104", TAG+="uaccess"
      '')
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
