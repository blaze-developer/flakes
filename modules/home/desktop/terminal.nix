{ lib, config, ... }:
let
  cfg = config.terminal;
in
{
  options.terminal = {
    enable = lib.mkEnableOption "a terminal emulator" {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # programs.kitty = {
    #   enable = true;
    # };

    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 10;
            y = 10;
          };
          opacity = 0.65;
          blur = true;
        };

        cursor = {
          style = {
            shape = "Beam";
            blinking = "On";
          };

          vi_mode_style = {
            shape = "Underline";
            blinking = "On";
          };
        };
      };
    };
  };
}