{ lib, config, ... }:
let
  cfg = config.desktop.wm;
in 
{
  options.desktop.wm = {
    enable = lib.mkEnableOption "a window manager";

    display = lib.mkOption {
      type = lib.types.str;
      default = ", preferred, auto, 1.0";
      description = ''
        The display configuration to apply to the window manager. Uses hyprland config setup.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.variables = [ "--all" ];
      settings = {

        monitor = cfg.display;

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          resize_on_border = true;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        misc = {
          disable_hyprland_logo = true;
        };

        windowrule = [
          # XWayland window warning!
          # (
          #   let
          #     red = "rgb(240, 60, 40)";
          #     yellow = "rgb(248, 218, 68)";
          #     n = 3; # number of stripes
          #     stripe = builtins.concatStringsSep " " (
          #       builtins.genList (i: if lib.mod i 2 == 0 then red else yellow) (n)
          #     );
          #   in
          #     "border_color ${red}, match:xwayland true"
          # )
        ];

        exec-once = [
          "waybar"
          "hyprsunset"
        ];

        # Repeatable Bindings on Hold
        bindel = [
          ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"

          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        # Bindings always available
        bindl = [
          ", XF86AudioPlay, exec, playerctl play-pause"
        ];

        # Bindings only available when unlocked
        bind = [
          # Navigation
          "SUPER, RETURN, exec, alacritty"
          "SUPER, SPACE, exec, killall &  wofi --show drun"
          "SUPER, C, killactive,"
          "SUPER, M, exit,"
          "SUPER, B, exec, floorp"
          # "SUPER, P, psuedo,"
          "SUPER, F, togglefloating"
          "SUPER SHIFT, F, fullscreen"
          "SUPER, J, togglesplit,"

          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          # FKeys
          "SUPER SHIFT, S, exec, grimblast copy area"
          ", Print, exec, grimblast copy active"

          # Blue light filter
          "SUPER, N, exec, hyprctl hyprsunset temperature 1500" # night
          "SUPER, D, exec, hyprctl hyprsunset identity" # day

          # Passthroughs
          "CONTROL SHIFT, M, pass, class:vesktop"
          "CONTROL SHIFT, D, pass, class:vesktop"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "SUPER, code:1${toString i}, workspace, ${toString ws}"
                "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
      };
    };
  };
}