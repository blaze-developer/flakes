{ config, pkgs, lib, inputs, ... }:

{
  home = {
    username = "lia";
    homeDirectory = "/home/lia";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    
    # Apps
    floorp
    vesktop
    spotify
    jetbrains.idea-community
    jdk

    # Robotics Apps
    advantagescope
    elastic-dashboard
    pathplanner
    
    # Desktop Packages
    font-awesome
    brightnessctl
    playerctl
    wl-clipboard
    grimblast
    wev
    hyprsunset

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ]
  ++ [
    (pkgs.writeShellScriptBin "rebuild" ''
      sudo nixos-rebuild switch --flake ~/Flakes
    '')
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 10; y = 10; };
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

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    settings = {
      
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
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

      windowrule = [
        # XWayland window warning!
        (
          let
            red = "rgb(240, 60, 40)";
            yellow = "rgb(248, 218, 68)";
            n = 3; # number of stripes
            stripe = builtins.concatStringsSep " " (
              builtins.genList (i: if lib.mod i 2 == 0 then red else yellow) (n)
            );
          in
            "bordercolor ${stripe}, xwayland:1"
        )
      ];

      env = [
        "EDITOR, vim"
        "NIXOS_OZONE_WL, 1"
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

      bind = [
	# Navigation
        "SUPER, RETURN, exec, alacritty"
        "SUPER, SPACE, exec, wofi --show drun"
        "SUPER, C, killactive,"
        "SUPER, M, exit,"
        "SUPER, B, exec, floorp"
        # "SUPER, P, psuedo,"
        "SUPER, J, togglesplit,"
        
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        # FKeys
        "SUPER SHIFT, S, exec, grimblast copy area"
        ", Print, exec, grimblast copy"

        "SUPER, N, exec, hyprctl hyprsunset temperature 1500"
        "SUPER, D, exec, hyprctl hyprsunset identity"

        # Passthroughs
        "CONTROL SHIFT, M, pass, class:vesktop"
        "CONTROL SHIFT, D, pass, class:vesktop"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "SUPER, code:1${toString i}, workspace, ${toString ws}"
              "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
    };
  };

  programs.wofi.enable = true;

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      modules-left = [
        "hyprland/workspaces"
      ];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "battery"
        "tray"
      ];
      modules-center = [
        "clock"
      ];
      
      tray.spacing = 10;
      
      cpu = {
        format = "{usage}%";
        tooltip = false;
      };

      memory.format = "{}% ";

      battery = {
        format = "{capacity}% {icon}";
        format-icons = ["" "" "" "" ""];
      };

      clock.format-alt = "{:%a, %d. %b  %H:%M}";

      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };

      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
        };
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    
    profiles.default = {
      userSettings = {
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdate" = false;
        "editor.minimap.enabled" = false;

        "workbench.colorTheme" = "Atomize";
      };
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        emroussel.atomize-atom-one-dark-theme

        # Java
        wpilibsuite.vscode-wpilib
        # vscjava.vscode-java-pack
        redhat.java
      ];
    };
  };

  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        name = "blaze-developer";
        email = "bryceblazegaming@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lia/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    NIXOS_OZONE_WL = 1;
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
