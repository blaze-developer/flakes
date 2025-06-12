{ config, pkgs, lib, inputs, ... }:

{
  home = {
    username = "lia";
    homeDirectory = "/home/lia";
    stateVersion = "25.05";
  };

  home.shellAliases = {
    ns = "sudo nixos-rebuild switch --flake ~/Flakes";
    nt = "sudo nixos-rebuild test --flake ~/Flakes";
    nto = "sudo nixos-rebuild test --flake ~/Flakes";
    rebuild = "ns";
    nya = "nyancat";
  };

  home.sessionVariables = {
    EDITOR = "vim";
    NIXOS_OZONE_WL = 1;
  };

  # Pywal File (i should probably modularize and i know, ill do it soon lol)
  home.file.".config/wal/templates/colors-hyprland.conf".source = ./templates/colors-hyprland.conf;
  
  # Let HM Manage Shell (to make the above bashrc work)
  programs.bash.enable = true;

  # Pretty Prompt
  programs.starship.enable = true;

  home.packages = with pkgs; [
    
    # Apps
    floorp
    spotify
    jdk

    (jetbrains.idea-community-bin.override {
      vmopts = ''
        -Dawt.toolkit.name=WLToolkit
      '';
    })

    # Robotics Apps
    advantagescope
    elastic-dashboard
    pathplanner
    
    # Desktop Packages
    nerd-fonts.fira-code
    brightnessctl
    playerctl
    wl-clipboard
    grimblast
    wev
    hyprsunset
    swww
    iio-hyprland

    # Cli Apps
    nyancat
    unimatrix
    cava
    ani-cli

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
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

      source = "~/.cache/wal/colors-hyprland.conf";
      
      monitor = "eDP-1, preferred, auto, 1.2";

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

      misc = {
        disable_hyprland_logo = true;
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
            "bordercolor ${red}, xwayland:1"
        )
      ];

      exec-once = [
        "waybar"
        "hyprsunset"
        "iio-hyprland"
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
        "SUPER, F, togglefloating"
        "SUPER, J, togglesplit,"
        
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        # FKeys
        "SUPER SHIFT, S, exec, grimblast copy area"
        ", Print, exec, grimblast copy"

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

  services.swww.enable = true;
  programs.pywal.enable = true;

  programs.bash.initExtra = ''
    (cat ~/.cache/wal/sequences &)
  '';

  programs.waybar = {
    enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      modules-left = [
        "hyprland/window"
      ];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "battery"
        "clock"
        "tray"
      ];
      modules-center = [
        "hyprland/workspaces"
      ];
      
      tray.spacing = 10;
      
      cpu = {
        format = "{usage}% ";
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

    # style = ''
      
    # '';
  };

  programs.vesktop = {
    enable = true;
    # vencord.settings = {
    #   autoUpdate = false;
    #   autoUpdateNotification = false;
    #   notifyAboutUpdates = false;
    #   useQuickCSS = true;
    #   cloud = {
    #     authenticated = false;
    #     url = "https://api.vencord.dev/";
    #     settingsSync = true;
    #   };
    # };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    
    profiles.default = {
      userSettings = {
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdate" = false;
        "editor.minimap.enabled" = true;

        "workbench.colorTheme" = "Wal";
      };
      extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
        jnoortheen.nix-ide
        # dlasagno.wal-theme (must install imperatively for it to work :< )

        # Java
        wpilibsuite.vscode-wpilib
        redhat.java
        vscjava.vscode-maven
        vscjava.vscode-gradle
        vscjava.vscode-java-debug
        vscjava.vscode-java-test
        vscjava.vscode-java-dependency
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

}
