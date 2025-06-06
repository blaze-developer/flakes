{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    frc.url = "github:frc5541/frc-nix";
  };

  outputs = { self, nixpkgs }: {
  
    nixosConfigurations.futaba = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };

  };
}
