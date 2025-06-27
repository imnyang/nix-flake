{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelModules = [ "nvidia" "nvidia_drm" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.forceFullCompositionPipeline = true;
  hardware.nvidia.open = false;
  hardware.nvidia.powerManagement.enable = true;

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GL_GSYNC_ALLOWED = "0";
    KWIN_DRM_USE_MODIFIERS = "1";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NVD_BACKEND = "direct";
  };
}
