{ lib, config, ... }:
let 
  cfg = config.drivers.nvidia;
in 
{
  options.drivers.nvidia = {
    enable = lib.mkEnableOption "nvidia drivers";
    # hybrid = {
    #   enable = lib.mkEnableOption "optimus prime gpu hybridization";
    # };
  };

  
  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

    hardware.nvidia = {

      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = true;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # services.xserver.videoDrivers = lib.mkIf cfg.hybrid.enable [ "modesetting" ];

    # THESE BUS ID'S SHOULD BE CONFIGURABLE
    hardware.nvidia.prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
  };
}
