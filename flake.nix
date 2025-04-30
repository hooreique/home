{
  description = "Home Manager configuration of song";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nide = {
      url = "github:hooreique/nide";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    lepo = {
      url = "github:lepo-cli/lepo";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs: inputs.flake-utils.lib.eachSystem [
    "x86_64-linux" "aarch64-darwin"
  ] (system: {
    packages.homeConfigurations = {
      song = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          system = system;
          overlays = [
            (final: prev: { nide = inputs.nide.packages.${system}.default; })
            (final: prev: { lepo = inputs.lepo.packages.${system}.default; })
          ];
        };
        extraSpecialArgs = {
          currSys = system;
        };
        modules = [ ./home.nix ];
      };
    };
  });
}
