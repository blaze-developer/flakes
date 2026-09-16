{ lib, config, pkgs, ... }: 
let
  cfg = config.suites.robotics;

  vscode-wpilib = pkgs.vscode-extensions.wpilibsuite.vscode-wpilib;

  vscode-wpilib-2027 = vscode-wpilib.overrideAttrs (oldAttrs: rec {
    version = "2027.0.0-alpha-7";

    src = pkgs.fetchurl {
      url = "https://github.com/wpilibsuite/vscode-wpilib/releases/download/v${version}/vscode-wpilib-${version}.vsix";
      hash = "sha256-yVz7kAgIVBET2Iadb9tGP4vE7prsAac9+u7CjVlqbIc=";
      # TODO: Once the version of nixpkgs in this flake is updated we should remove
      # the custom `name` and the `unzip` nativeBuildInput
      # See: https://github.com/NixOS/nixpkgs/commit/e24a734076ea21365bb618d63f5c9a70006dd196

      # For compatibility older versions of nixpkgs
      # The `*.vsix` file is in the end a simple zip file. Change the extension
      # so that existing `unzip` hooks takes care of the unpacking.
      name = "${oldAttrs.name}.zip";
    };
  });
in 
{
  options.suites.robotics = {
    enable = lib.mkEnableOption "Robotics home manager configurations.";
    systemcore = lib.mkEnableOption "systemcore alpha versions";
  };

  config = lib.mkIf cfg.enable {
    programs.vscodium.profiles.default.extensions = [
      (if cfg.systemcore then vscode-wpilib-2027 else vscode-wpilib)
    ];
  };
}
