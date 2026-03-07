# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  inputs,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.android_sdk.accept_license = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      # allowedTCPPorts = [ ];
      # allowedUDPPorts = [ ];
      enable = true;
    };
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lia = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # PROGRAMS

  programs.hyprland.enable = true; # Installs system-wide required stuff for hyprland to work.

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libglvnd
    glib
    nspr
    nss_latest
    dbus
    atk
    cups
    cairo
    gtk3
    pango
    libgbm
    expat
    libxkbcommon
    alsa-lib
    libGL
    libx11
    libxrandr
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxcb
  ];

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    kitty
    btop
    killall
    jq
    appimage-run
    mesa
    ffmpeg
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # SERVICES

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.tailscale = {
    enable = false;
    useRoutingFeatures = "client";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

}
