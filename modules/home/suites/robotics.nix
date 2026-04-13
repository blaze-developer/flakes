{ lib, config, pkgs }: 
let
  cfg = config.suites.robotics;
in 
{
  options.suites.robotics.enable = lib.mkEnableOption "Robotics home manager configurations.";

  config = lib.mkIf cfg.enable {
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      wpilibsuite.vscode-wpilib
    ];
  };
}