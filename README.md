# 🚀 Neko's NixOS Configuration

현대적이고 최적화된 NixOS flake 설정입니다.

**Repository**: https://github.com/imnyang/nix-flake

## ✨ 주요 특징

- **🏠 Home Manager 통합**: 사용자별 설정을 선언적으로 관리
- **🎮 NVIDIA + Wayland**: 최적화된 NVIDIA 드라이버와 Wayland 지원
- **🔧 개발 환경**: 다양한 프로그래밍 언어와 도구들 사전 설정
- **📦 패키지 관리**: 안정 버전과 최신 버전 패키지 혼용
- **⚡ 성능 최적화**: 시스템 성능과 안정성을 위한 세부 튜닝
- **🛡️ 보안 강화**: 적절한 권한 관리와 보안 설정

## 🗂️ 프로젝트 구조

```
.
├── flake.nix              # 메인 flake 설정
├── home.nix               # Home Manager 설정
├── hostname.nix           # 호스트명 설정
├── hardware-configuration.nix  # 하드웨어 설정 (자동 생성)
├── scripts/
│   └── manage.sh          # 시스템 관리 스크립트
└── modules/
    ├── boot.nix           # 부트로더 설정
    ├── desktop.nix        # 데스크톱 환경 (KDE Plasma 6)
    ├── locale.nix         # 지역/시간대 설정
    ├── nvidia.nix         # NVIDIA 드라이버 설정
    ├── packages.nix       # 시스템 패키지
    ├── performance.nix    # 성능 최적화 (선택사항)
    └── system.nix         # 시스템 기본 설정
```

## 🚀 설치 및 사용법

### 1. 초기 설치

```bash
# 리포지토리 클론
git clone https://github.com/imnyang/nix-flake.git
cd nix-flake

# 호스트명 및 사용자명 확인/수정
# flake.nix의 hostname과 username을 실제 환경에 맞게 수정

# 하드웨어 설정 생성 (실제 설치 시)
sudo nixos-generate-config --root /mnt

# 시스템 빌드 및 적용
sudo nixos-rebuild switch --flake .#neko-desktop
```

## 🛠️ 개발 환경

이 flake는 다음 개발 도구들을 포함합니다:

- **언어**: Python 3, Node.js, Rust, Go, C/C++
- **에디터**: Neovim, VS Code, Zed
- **도구**: Git, Docker, tmux, fzf, ripgrep
- **터미널**: Ghostty, 향상된 shell 설정

개발 shell 진입:
```bash
nix develop
```

## 📝 주요 개선사항

1. **Home Manager 통합**: 사용자별 설정을 체계적으로 관리
2. **보안 강화**: NOPASSWD sudo 제거, 적절한 권한 관리
3. **성능 최적화**: 시스템 튜닝, Zram, SSD 최적화
4. **개발 환경 개선**: 최신 도구들과 shell 설정
5. **관리 스크립트**: 일상적인 시스템 관리 자동화
6. **Wayland 최적화**: NVIDIA와 Wayland의 호환성 개선
7. **패키지 구조화**: 카테고리별 패키지 분류

## 📄 라이선스

이 설정은 자유롭게 사용하고 수정할 수 있습니다.
