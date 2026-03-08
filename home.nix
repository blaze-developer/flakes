{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  stable = inputs.stable.legacyPackages."x86_64-linux";
in
{
  home = {
    username = "lia";
    homeDirectory = "/home/lia";
  };

  home.shellAliases = {
    ns = "sudo nixos-rebuild switch --flake ~/flakes";
    nt = "sudo nixos-rebuild test --flake ~/flakes";
    nto = "sudo nixos-rebuild test --flake ~/flakes";
    rebuild = "ns";
    nya = "nyancat";
    hypr = "start-hyprland";
  };

  home.sessionVariables = {
    EDITOR = "vim";
    NIXOS_OZONE_WL = 1;
    NODE_OPTIONS = "--max-old-space-size=16384";
  };

  # Pywal File (i should probably modularize and i know, ill do it soon lol)
  home.file.".config/wal/templates/colors-hyprland.conf".source = ./templates/colors-hyprland.conf;

  # Let HM Manage Shell (to make the above bashrc work)
  programs.bash.enable = true;

  programs.hyfetch = {
    enable = true;
  };

  programs.fastfetch = {
    enable = true;
  };

  home.packages =
    with pkgs;
    [

      spotify
      jdk
      python3
      nodejs_25

      # (jetbrains.idea-oss.override {
      #   vmopts = ''
      #     -Dawt.toolkit.name=WLToolkit
      #   '';
      # })

      unityhub
      jetbrains.rider
      blender

      orca-slicer

      # android-studio
      android-tools

      (pkgs.symlinkJoin {
        name = "android-studio-wayland";
        paths = [ pkgs.android-studio ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/android-studio \
            --add-flags "-Dawt.toolkit.name=WLToolkit"
        '';
      })

      okteta

      # Desktop Packages
      nerd-fonts.fira-code
      brightnessctl
      playerctl
      wl-clipboard
      grimblast
      wev
      hyprsunset
      xdg-desktop-portal-hyprland
      pywalfox-native
      gsettings-desktop-schemas
      glib

      # Cli Apps
      nyancat
      unimatrix
      cava
      ani-cli
      blahaj
      yt-dlp
      nixd
      nixfmt
      nixos-generators
      gh

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    ];

  programs.wofi.enable = true;

  programs.pywal.enable = true;

  programs.bash.initExtra = ''
    (cat ~/.cache/wal/sequences &)
  '';

  programs.floorp = {
    enable = true;

    profiles.default = {
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
      ];
    };
  };

  programs.vesktop = {
    enable = true;
    vencord.settings = {
      autoUpdate = false;
      autoUpdateNotification = false;
      notifyAboutUpdates = false;
    };
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

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";

        "direnv.restart.automatic" = true;

        "redhat.telemetry.enabled" = false;

        "files.associations" = {
          "*.json" = "jsonc";
        };
      };
      extensions =
        with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide
          # dlasagno.wal-theme
          mkhl.direnv

          # Java
          redhat.java
          vscjava.vscode-maven
          vscjava.vscode-gradle
          vscjava.vscode-java-debug
          vscjava.vscode-java-test
          vscjava.vscode-java-dependency
          wpilibsuite.vscode-wpilib

        ];
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "blaze-developer";
        email = "bryceblazegaming@gmail.com";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      vo = "gpu-next"; # Better Wayland support
      gpu-context = "wayland";
    };
  };

}
