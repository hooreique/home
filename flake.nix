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
    system = "aarch64-linux";
    my-pkgs.fall  = inputs.fall.packages.${system}.default;
    my-pkgs.hvim  = inputs.hvim.packages.${system}.default;
    my-pkgs.saseo = inputs.saseo.packages.${system}.default;
  in {
    packages.${system}.homeConfigurations.song = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.hisle.overlay
        ];
      };
      extraSpecialArgs = { inherit my-pkgs; };
      modules = [
        inputs.hisle.homeManagerModule
        {
          home.username = "song";
          home.homeDirectory = "/home/song";
        }
        ./home.nix
      ];
    };
  };
}
