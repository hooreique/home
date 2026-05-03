{
  description = "Home Manager configuration of song";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    fall.url         = "github:hooreique/fall";
    hvim.url         = "github:hooreique/hvim";
  };

  outputs = inputs: inputs.flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-darwin" "aarch64-linux"] (system: let
    username = "song";
    my-pkgs.fall = inputs.fall.packages.${system}.default;
    my-pkgs.hvim = inputs.hvim.packages.${system}.default;
  in {
    packages.homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit my-pkgs; };
      modules = [
         {
           home.username = username;
           home.homeDirectory = if system == "aarch64-darwin" then "/Users/${username}" else "/home/${username}";
         }
        ./home.nix
        ./home-darwin.nix
      ];
    };
  });
}
