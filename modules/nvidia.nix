{ config, pkgs, ... }:

{
  # NVIDIA 드라이버 설정
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # 커널 모듈
  boot.kernelModules = [ "nvidia" "nvidia_drm" "nvidia_uvm" "nvidia_modeset" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  
  # 커널 파라미터 (DRM 지원)
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # NVIDIA 하드웨어 설정
  hardware.nvidia = {
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    open = false;  # 오픈소스 드라이버 비활성화 (안정성)
    
    # 전력 관리
    powerManagement.enable = true;
    powerManagement.finegrained = false;  # 하이브리드 그래픽스가 아닌 경우
    
    # NVIDIA 설정 GUI
    nvidiaSettings = true;
    
    # 드라이버 패키지 (최신 안정 버전)
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # 환경 변수 (Wayland + NVIDIA)
  environment.variables = {
    # OpenGL 설정
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    
    # Wayland 관련
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";  # Wayland 커서 문제 해결
    
    # G-Sync 비활성화 (Wayland에서 문제 방지)
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    
    # KDE Wayland 설정
    KWIN_DRM_USE_MODIFIERS = "1";
    QT_QPA_PLATFORM = "wayland";
    
    # Firefox Wayland
    MOZ_ENABLE_WAYLAND = "1";
    
    # NVIDIA 직접 백엔드
    NVD_BACKEND = "direct";
    
    # CUDA 설정 (개발용)
    CUDA_CACHE_PATH = "$HOME/.nv/ComputeCache";
  };
  
  # OpenGL 하드웨어 가속
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
