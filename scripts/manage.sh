#!/usr/bin/env bash

# NixOS 시스템 관리 스크립트
# 사용법: ./scripts/manage.sh [command]

set -e

# 현재 디렉토리를 flake 디렉토리로 사용 (스크립트가 있는 위치의 상위 디렉토리)
FLAKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOSTNAME="neko-desktop"  # flake.nix의 hostname과 일치해야 함

cd "$FLAKE_DIR"

case "${1:-help}" in
    "rebuild" | "switch")
        echo "🔧 시스템 rebuild 중..."
        echo "📋 실행할 명령어: sudo nixos-rebuild switch --flake \".#$HOSTNAME\""
        if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
            sudo nixos-rebuild switch --flake ".#$HOSTNAME"
            echo "✅ 시스템 rebuild 완료!"
        else
            echo "⚠️  sudo 권한이 필요합니다. 다음 명령어를 직접 실행하세요:"
            echo "sudo nixos-rebuild switch --flake \".#$HOSTNAME\""
        fi
        ;;
    
    "test")
        echo "🧪 시스템 테스트 빌드 중..."
        echo "📋 실행할 명령어: sudo nixos-rebuild test --flake \".#$HOSTNAME\""
        if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
            sudo nixos-rebuild test --flake ".#$HOSTNAME"
            echo "✅ 테스트 빌드 완료!"
        else
            echo "⚠️  sudo 권한이 필요합니다. 다음 명령어를 직접 실행하세요:"
            echo "sudo nixos-rebuild test --flake \".#$HOSTNAME\""
        fi
        ;;
    
    "boot")
        echo "🔄 다음 부팅시 적용되는 설정 빌드 중..."
        echo "📋 실행할 명령어: sudo nixos-rebuild boot --flake \".#$HOSTNAME\""
        if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
            sudo nixos-rebuild boot --flake ".#$HOSTNAME"
            echo "✅ 부트 설정 완료! 재부팅 후 적용됩니다."
        else
            echo "⚠️  sudo 권한이 필요합니다. 다음 명령어를 직접 실행하세요:"
            echo "sudo nixos-rebuild boot --flake \".#$HOSTNAME\""
        fi
        ;;
    
    "update")
        echo "📦 Flake inputs 업데이트 중..."
        nix flake update
        echo "✅ 업데이트 완료!"
        ;;
    
    "upgrade")
        echo "🚀 시스템 전체 업그레이드 중..."
        nix flake update
        echo "📋 실행할 명령어: sudo nixos-rebuild switch --flake \".#$HOSTNAME\""
        if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
            sudo nixos-rebuild switch --flake ".#$HOSTNAME"
            echo "✅ 업그레이드 완료!"
        else
            echo "⚠️  sudo 권한이 필요합니다. 다음 명령어를 직접 실행하세요:"
            echo "sudo nixos-rebuild switch --flake \".#$HOSTNAME\""
        fi
        ;;
    
    "build")
        echo "🔨 시스템 빌드 테스트 중 (설치 없음)..."
        nix build ".#nixosConfigurations.$HOSTNAME.config.system.build.toplevel" --no-link
        echo "✅ 빌드 테스트 완료!"
        ;;
    
    "dry-run")
        echo "🔍 Dry-run 빌드 중..."
        nix build ".#nixosConfigurations.$HOSTNAME.config.system.build.toplevel" --dry-run
        echo "✅ Dry-run 완료!"
        ;;
    
    "clean")
        echo "🧹 시스템 정리 중..."
        echo "  - 가비지 컬렉션 실행..."
        echo "📋 실행할 명령어: sudo nix-collect-garbage -d"
        if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
            sudo nix-collect-garbage -d
            echo "  - 부트 항목 정리..."
            sudo /run/current-system/bin/switch-to-configuration boot
            echo "✅ 정리 완료!"
        else
            echo "⚠️  sudo 권한이 필요합니다. 다음 명령어들을 직접 실행하세요:"
            echo "sudo nix-collect-garbage -d"
            echo "sudo /run/current-system/bin/switch-to-configuration boot"
        fi
        ;;
    
    "dev")
        echo "🛠️  개발 환경 진입 중..."
        nix develop
        ;;
    
    "check")
        echo "🔍 설정 문법 검사 중..."
        nix flake check
        echo "✅ 문법 검사 완료!"
        ;;
    
    "generations")
        echo "📜 시스템 세대 목록:"
        echo "📋 실행할 명령어: sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"
        if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
            sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
        else
            echo "⚠️  sudo 권한이 필요합니다. 다음 명령어를 직접 실행하세요:"
            echo "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"
        fi
        ;;
    
    "rollback")
        echo "⏪ 이전 세대로 롤백 중..."
        echo "📋 실행할 명령어: sudo nixos-rebuild switch --rollback"
        if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
            sudo nixos-rebuild switch --rollback
            echo "✅ 롤백 완료!"
        else
            echo "⚠️  sudo 권한이 필요합니다. 다음 명령어를 직접 실행하세요:"
            echo "sudo nixos-rebuild switch --rollback"
        fi
        ;;
    
    "status")
        echo "📊 시스템 상태:"
        echo "  현재 세대:"
        if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
            sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1
        else
            echo "  (sudo 권한 필요: sudo nix-env --list-generations --profile /nix/var/nix/profiles/system)"
        fi
        echo "  Flake 상태:"
        nix flake metadata
        ;;
    
    "help" | *)
        echo "🔧 NixOS 관리 스크립트"
        echo ""
        echo "사용법: $0 [command]"
        echo ""
        echo "명령어:"
        echo "  rebuild   - 시스템을 rebuild하고 즉시 적용 (sudo 필요)"
        echo "  test      - 테스트 빌드 (재부팅 없이 임시 적용, sudo 필요)"
        echo "  boot      - 다음 부팅시 적용할 설정 빌드 (sudo 필요)"
        echo "  update    - flake inputs 업데이트"
        echo "  upgrade   - 전체 시스템 업그레이드 (update + rebuild, sudo 필요)"
        echo "  build     - 시스템 빌드 테스트 (설치 없음, sudo 불필요)"
        echo "  dry-run   - 빌드 계획 확인 (sudo 불필요)"
        echo "  clean     - 가비지 컬렉션 및 정리 (sudo 필요)"
        echo "  dev       - 개발 환경 진입"
        echo "  check     - 설정 문법 검사"
        echo "  generations - 시스템 세대 목록 확인 (sudo 필요)"
        echo "  rollback  - 이전 세대로 롤백 (sudo 필요)"
        echo "  status    - 시스템 상태 확인"
        echo "  help      - 이 도움말 표시"
        echo ""
        echo "💡 컨테이너 환경에서는 'build' 또는 'dry-run'을 사용하여 설정을 검증할 수 있습니다."
        ;;
esac
