{
  description = "Home Manager configuration of song";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    fall.url         = "github:hooreique/fall";
    hvim.url         = "github:hooreique/hvim";
    saseo.url        = "github:hooreique/saseo";

    # For nixos-gnome
    nixpkgs-de.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nur.url        = "github:nix-community/NUR";
    soop.url       = "github:hooreique/soop";
    spoofdpium.url = "github:hooreique/spoofdpium";
  };

  outputs = inputs: let
    system = "x86_64-linux";
    my-pkgs.fall  = inputs.fall.packages.${system}.default;
    my-pkgs.hvim  = inputs.hvim.packages.${system}.default;
    my-pkgs.saseo = inputs.saseo.packages.${system}.default;
  in {
    homeConfigurations.song = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
        ];
      };
      extraSpecialArgs = {
        inherit my-pkgs;
        de-pkgs = import inputs.nixpkgs-de {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            inputs.nur.overlays.default
            inputs.soop.overlays.default
            inputs.spoofdpium.overlays.default
          ];
        };
      };
      modules = [
        {
          home.username = "song";
          home.homeDirectory = "/home/song";
        }
        ./home.nix
        ./home-nixos-gnome.nix
      ];
    };
  };
}
