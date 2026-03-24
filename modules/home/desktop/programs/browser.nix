{ lib, config, inputs, ... }:
let
  cfg = config.desktop.programs.browser;
in
{
  options.desktop.programs.browser = {
    enable = lib.mkEnableOption "web browser";
  };

  config = lib.mkIf cfg.enable {
    programs.floorp = {
      enable = true;

      profiles.default = {
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          pywalfox
          dearrow
          tabliss
        ];

        extensions.force = true;

        settings.extensions = {
          autoDisableScopes = 0;
          update.autoUpdateDefault = false;
          update.enabled = false;
        };
      };
    };
  };
}