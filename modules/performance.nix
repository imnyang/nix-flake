{ config, pkgs, ... }:

{
  # 시스템 모니터링 및 성능 최적화
  
  # 시스템 서비스들
  services.thermald.enable = true;  # 열 관리
  services.irqbalance.enable = true;  # IRQ 밸런싱
  services.earlyoom.enable = true;  # 메모리 부족시 자동 종료
  services.earlyoom.freeMemThreshold = 5;  # 5% 남으면 작동
  
  # 성능 관련 커널 파라미터
  boot.kernel.sysctl = {
    # 네트워크 성능 향상
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "net.ipv4.tcp_rmem" = "4096 87380 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";
    "net.ipv4.tcp_congestion_control" = "bbr";
    
    # 메모리 관리
    "vm.swappiness" = 10;  # 스왑 사용 최소화
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 10;
    
    # 파일 시스템
    "fs.inotify.max_user_watches" = 524288;  # IDE 등에서 파일 감시
  };
  
  # Zram (압축 스왑)
  zramSwap = {
    enable = true;
    algorithm = "zstd";  # 빠른 압축
    memoryPercent = 25;  # RAM의 25%를 zram으로
  };
  
  # 로그 관리
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    SystemMaxFiles=10
  '';
  
  # 자동 업데이트 (선택사항)
  system.autoUpgrade = {
    enable = false;  # 수동으로 관리하려면 false
    dates = "weekly";
    flake = "/home/neko/Workspace/imnyang/nix-flake";
  };
  
  # 성능 프로파일
  powerManagement.cpuFreqGovernor = "performance";  # 또는 "schedutil"
  
  # SSD 최적화 (SSD 사용시)
  services.fstrim.enable = true;  # 주간 TRIM
  
  # 파일 시스템 최적화
  fileSystems."/".options = [ "noatime" "nodiratime" ];  # 접근 시간 기록 비활성화
}
