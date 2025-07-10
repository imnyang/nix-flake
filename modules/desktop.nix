{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  # Display Manager & Desktop Environment
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;  # Wayland 지원
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enableQt5Integration = true;
  #services.xserver.windowManager.xwayland.enable = true;

  services.printing.enable = true;

  services.xserver.xkb = {
    layout = "kr";
    variant = "";
  };

  programs.firefox.enable = true;

  # Wayland 환경 변수
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Electron 앱들의 Wayland 지원
    MOZ_ENABLE_WAYLAND = "1";  # Firefox Wayland 지원
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };
  };

  # XDG 포털 (Wayland 앱 통합)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
