{
  description = "Home Manager configuration of song";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fall = {
      url = "github:hooreique/fall";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
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
  ] (system: let username = "song"; in {
    packages.homeConfigurations = {
      ${username} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (final: prev: { fall = inputs.fall.packages.${system}.default; })
            (final: prev: { nide = inputs.nide.packages.${system}.default; })
            (final: prev: { lepo = inputs.lepo.packages.${system}.default; })
          ];
        };
        extraSpecialArgs = { inherit system; inherit username; };
        modules = [ ./home.nix ];
      };
    };
  });
}
