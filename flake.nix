{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    frc.url = "github:frc4451/frc-nix";
  };

  outputs = { self, nixpkgs, frc }: {
  
    nixosConfigurations.futaba = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
      ];
    };

  };
}
