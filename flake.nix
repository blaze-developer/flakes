{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    frc-nix.url = "github:frc4451/frc-nix";
  };

  outputs = { nixpkgs, ... } @ inputs: {
    inputs.frc-nix
    nixosConfigurations.futaba = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
