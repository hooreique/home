{
  description = "Home Manager configuration of song";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lepo = {
      url = "github:lepo-cli/lepo";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, lepo }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-darwin" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [(final: prev: {
            lepo = lepo.defaultPackage.${system};
          })];
        };
      in {
        packages.homeConfigurations = {
          song = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgs;
            modules = [ ./home.nix ];
            extraSpecialArgs = {
              currSys = system;
            };
          };
        };
      });
}
