{
  description = "Home Manager configuration of song";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    fall.url = "github:hooreique/fall";
  };

  outputs = inputs: inputs.flake-utils.lib.eachSystem [
    "x86_64-linux"  "aarch64-darwin"  "aarch64-linux"
  ] (system: let username = "song"; in {
    packages.homeConfigurations = {
      ${username} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (final: prev: { fall = inputs.fall.packages.${system}.default; })
          ];
        };
        extraSpecialArgs = { inherit username; };
        modules = [
          ./home.nix
          ./home-darwin.nix
        ];
      };
    };
  });
}
