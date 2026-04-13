# Phasing this out in favor of modules
{
  pkgs,
  ...
}:
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
    PROTON_ENABLE_WAYLAND = 1;
    NODE_OPTIONS = "--max-old-space-size=25000";
  };

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

      unityhub
      jetbrains.rider
      blender

      orca-slicer

      okteta

      # Desktop Packages
      nerd-fonts.fira-code
      brightnessctl
      playerctl
      wl-clipboard
      grimblast
      wev
      hyprsunset
      pywalfox-native

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


  # Pretty Prompt
  programs.starship.enable = true;

}
