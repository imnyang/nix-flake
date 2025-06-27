{
  description = "Neko Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        packages.default = pkgs.hello; # 필요시 삭제
      }
    ) // {

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hostname.nix
          ./hardware-configuration.nix

          ./modules/boot.nix
          ./modules/locale.nix
          ./modules/desktop.nix
          ./modules/nvidia.nix
          ./modules/packages.nix
          ./modules/system.nix
          {
            system.stateVersion = "25.05";
          }
        ];
      };

    };
}
