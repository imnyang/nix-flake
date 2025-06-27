{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # 그래픽 및 NVIDIA 관련
    config.boot.kernelPackages.nvidia_x11
    vulkan-tools
    glxinfo
    nvtopPackages.full

    # 개발 도구
    gcc
    gnumake
    python3
    nodejs
    bun
    git
    vim
    neovim
    vscode-fhs
    tmux
    uv
    gh

    # 네트워크 및 디버깅 툴
    wget
    curl
    btop
    unzip
    tree
    killall
    pciutils
    usbutils
    lsof
    strace

    caido
    burpsuite

    # 기타 유틸리티
    fastfetch
    fd
    ripgrep
    fzf
    ntfs3g
    kime

    # GUI
    vesktop
    ghostty
    zed-editor
  ];
}
