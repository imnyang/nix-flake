{ config, pkgs, pkgs-unstable, ... }:

{
  # Home Manager 기본 설정
  home.username = "neko";
  home.homeDirectory = "/home/neko";
  home.stateVersion = "25.05";

  # Git 설정
  programs.git = {
    enable = true;
    userName = "imnyang";
    userEmail = "me@imnya.ng"; # 실제 이메일로 변경하세요
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
    };
  };

  # Shell 설정 (bash)
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      
      # NixOS 관련 별칭
      rebuild = "sudo nixos-rebuild switch --flake .";
      update = "nix flake update";
      clean = "sudo nix-collect-garbage -d";
      
      # 편의성 별칭
      vi = "nvim";
      vim = "nvim";
      cat = "bat";
      ls = "eza";
      find = "fd";
    };
    
    bashrcExtra = ''
      # 프롬프트 개선
      export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      
      # 히스토리 설정
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      
      # 개발 환경 변수
      export EDITOR=nvim
      export BROWSER=firefox
    '';
  };

  # 개발 도구 설정
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set smartindent
      set wrap
      set ignorecase
      set smartcase
      set incsearch
      set hlsearch
      
      " 기본 키 매핑
      inoremap jk <Esc>
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l
    '';
  };

  # 터미널 도구들
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # 유저별 패키지 (개발 도구나 GUI 앱들)
  home.packages = with pkgs; [
    # 터미널 도구 개선
    bat         # cat 대체
    eza         # ls 대체
    fd          # find 대체
    ripgrep     # grep 대체
    tokei       # 코드 통계
    hyperfine   # 벤치마킹
    
    # 개발 도구
    jq          # JSON 처리
    yq          # YAML 처리
    httpie      # HTTP 클라이언트
    
    # 시스템 모니터링
    bottom      # top 대체 (btop보다 가벼움)
    du-dust     # du 대체
    bandwhich   # 네트워크 모니터링
  ] ++ (with pkgs-unstable; [
    # unstable 채널에서 최신 버전이 필요한 패키지들
    # 예: zed-editor
  ]);

  # 서비스 설정
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # Home Manager가 시스템을 관리하도록 허용
  programs.home-manager.enable = true;
}
