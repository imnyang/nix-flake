{
  description = "Neko's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, home-manager, ... }:
    let
      system = "x86_64-linux";
      
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      
      hostname = builtins.getEnv "HOSTNAME";
      username = builtins.getEnv "USERNAME" or "neko";
    in
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # 개발 도구들
          gcc
          gnumake
          python3
          nodejs
          bun
          rustc
          cargo
          go
        ];
        
        shellHook = ''
          echo "🔧 개발 환경이 준비되었습니다!"
          echo "사용 가능한 도구들: gcc, python3, nodejs, bun, rust, go"
        '';
      };
    }) // {

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        
        specialArgs = { 
          inherit pkgs-unstable username;
        };

        modules = [
          (./. + "/hosts/${hostname}/hardware-configuration.nix")

          ./modules/boot.nix
          ./modules/locale.nix
          ./modules/desktop.nix
          (if hostname == "desktop" then ./modules/nvidia.nix else ./modules/dummy.nix)
          ./modules/packages.nix
          ./modules/system.nix
          # ./modules/performance.nix  # 성능 최적화 (필요시 주석 해제)
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
          }
          
          {
            system.stateVersion = "25.05";
            networking.hostName = hostname;
          }
        ];
      };

    };
}
