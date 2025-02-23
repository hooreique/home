{
  description = "Home Manager configuration of song";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }: flake-utils.lib.eachSystem [
    "x86_64-linux"
    "aarch64-darwin"
  ] (system: {
    packages.homeConfigurations.song = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./home.nix ];
      extraSpecialArgs.currSys = system;
    };
  });
}
