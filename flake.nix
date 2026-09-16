{
  description = "Home Manager configuration of song";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    fall.url         = "github:hooreique/fall";
    hvim.url         = "github:hooreique/hvim";
    saseo.url        = "github:hooreique/saseo";
    hisle.url        = "github:hooreique/hisle";
  };

  outputs = inputs: let
    system = "aarch64-darwin";
  in {
    homeConfigurations.song = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.fall.overlays.pinned
          inputs.hvim.overlays.pinned
          inputs.saseo.overlays.pinned
          inputs.hisle.overlay
        ];
      };
      extraSpecialArgs = {
      };
      modules = [
        inputs.hisle.homeManagerModule
        {
          home.username = "song";
          home.homeDirectory = "/Users/song";
        }
        ./home.nix
        ./home-macbook.nix
      ];
    };
  };
}
