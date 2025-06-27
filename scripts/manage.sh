#!/usr/bin/env bash

# NixOS 시스템 관리 스크립트
# 사용법: ./scripts/manage.sh [command]

set -e

FLAKE_DIR="/home/neko/Workspace/imnyang/nix-flake"
HOSTNAME="neko-desktop"  # flake.nix의 hostname과 일치해야 함

cd "$FLAKE_DIR"

case "${1:-help}" in
    "rebuild" | "switch")
        echo "🔧 시스템 rebuild 중..."
        sudo nixos-rebuild switch --flake ".#$HOSTNAME"
        echo "✅ 시스템 rebuild 완료!"
        ;;
    
    "test")
        echo "🧪 시스템 테스트 빌드 중..."
        sudo nixos-rebuild test --flake ".#$HOSTNAME"
        echo "✅ 테스트 빌드 완료!"
        ;;
    
    "boot")
        echo "🔄 다음 부팅시 적용되는 설정 빌드 중..."
        sudo nixos-rebuild boot --flake ".#$HOSTNAME"
        echo "✅ 부트 설정 완료! 재부팅 후 적용됩니다."
        ;;
    
    "update")
        echo "📦 Flake inputs 업데이트 중..."
        nix flake update
        echo "✅ 업데이트 완료!"
        ;;
    
    "upgrade")
        echo "🚀 시스템 전체 업그레이드 중..."
        nix flake update
        sudo nixos-rebuild switch --flake ".#$HOSTNAME"
        echo "✅ 업그레이드 완료!"
        ;;
    
    "clean")
        echo "🧹 시스템 정리 중..."
        echo "  - 가비지 컬렉션 실행..."
        sudo nix-collect-garbage -d
        echo "  - 부트 항목 정리..."
        sudo /run/current-system/bin/switch-to-configuration boot
        echo "✅ 정리 완료!"
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
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
        ;;
    
    "rollback")
        echo "⏪ 이전 세대로 롤백 중..."
        sudo nixos-rebuild switch --rollback
        echo "✅ 롤백 완료!"
        ;;
    
    "status")
        echo "📊 시스템 상태:"
        echo "  현재 세대: $(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1)"
        echo "  Flake 상태:"
        nix flake metadata
        ;;
    
    "help" | *)
        echo "🔧 NixOS 관리 스크립트"
        echo ""
        echo "사용법: $0 [command]"
        echo ""
        echo "명령어:"
        echo "  rebuild   - 시스템을 rebuild하고 즉시 적용"
        echo "  test      - 테스트 빌드 (재부팅 없이 임시 적용)"
        echo "  boot      - 다음 부팅시 적용할 설정 빌드"
        echo "  update    - flake inputs 업데이트"
        echo "  upgrade   - 전체 시스템 업그레이드 (update + rebuild)"
        echo "  clean     - 가비지 컬렉션 및 정리"
        echo "  dev       - 개발 환경 진입"
        echo "  check     - 설정 문법 검사"
        echo "  generations - 시스템 세대 목록 확인"
        echo "  rollback  - 이전 세대로 롤백"
        echo "  status    - 시스템 상태 확인"
        echo "  help      - 이 도움말 표시"
        ;;
esac
