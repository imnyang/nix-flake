{ config, pkgs, ... }:

{
  # Networking
  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # Nix 설정
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;

  # 폰트
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    fontconfig
    (pkgs.google-fonts.override { fonts = [ "Roboto" ]; })
  ];

  # 유저 설정
  users.users.neko = {
    isNormalUser = true;
    description = "neko";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" "storage" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # 보안 설정 개선 (NOPASSWD 제거)
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;  # wheel 그룹도 패스워드 필요
  };
  
  # 추가 보안 설정
  security.polkit.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
}
