{ lib, config, inputs, ... }:
let
  cfg = config.suites.aagl;
in 
{
  imports = [ inputs.aagl.nixosModules.default ];

  options.suites.aagl.enable = lib.mkEnableOption "Anime Game Launchers";

  config = lib.mkIf cfg.enable {

    programs.honkers-railway-launcher.enable = true;
  };
}