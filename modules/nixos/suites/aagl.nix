{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.suites.aagl;
in 
{
  options.suites.aagl.enable = lib.mkEnableOption "Anime Game Launchers";

  config = lib.mkIf cfg.enable {
    imports = [ inputs.aagl.nixosModules.default ];

    programs.honkers-railway-launcher.enable = true;
  };
}