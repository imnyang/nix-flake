{ config, pkgs, pkgs-unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # 동적 링킹 지원 개선 (AppImage, 바이너리 등)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    openssl
    curl
    glib
    util-linux
    glibc
    icu
    libunwind
    libuuid
    zlib
    libsecret
  ];

  environment.systemPackages = with pkgs; [
    # === 시스템 필수 도구 ===
    config.boot.kernelPackages.nvidia_x11
    vulkan-tools
    glxinfo
    nvtopPackages.full
    pciutils
    usbutils
    lsof
    strace
    killall
    
    # === 개발 도구 (시스템 레벨) ===
    gcc
    gnumake
    cmake
    pkg-config
    git
    vim
    neovim
    tmux
    
    # === 네트워크 및 다운로드 ===
    wget
    curl
    openssh
    
    # === 압축 및 파일 시스템 ===
    unzip
    zip
    p7zip
    tree
    ntfs3g
    
    # === 시스템 모니터링 ===
    btop
    fastfetch
    
    # === 개발 언어 및 런타임 ===
    python3
    python3Packages.pip
    python3Packages.virtualenv
    nodejs
    nodePackages.npm
    nodePackages.yarn
    bun
    uv
    gh
    
    # === 보안 도구 ===
    caido
    burpsuite
    
    # === 텍스트 처리 및 검색 ===
    fd
    ripgrep
    fzf
    
    # === 한국어 입력기 ===
    kime
    
    # === GUI 애플리케이션 ===
    vesktop
    ghostty
    vscode
  ] ++ (with pkgs-unstable; [
    # 최신 버전이 필요한 패키지들
    zed-editor
  ]);
  
  # 컨테이너 지원
  virtualisation.docker.enable = true;
  users.users.neko.extraGroups = [ "docker" ];
  
  # 개발 서비스 (필요시 활성화)
  services.postgresql = {
    enable = false;  # 필요할 때 true로 변경
    package = pkgs.postgresql_15;
  };
}
