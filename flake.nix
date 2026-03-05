{
  description = "Blazedev's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";

    frc-nix = {
      url = "github:frc4451/frc-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {

      nixosConfigurations = {

        # My Dell XPS Laptop
        joker = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./common.nix
            ./hosts/joker/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };

                users.lia = import ./hosts/joker/home.nix;
              };
            }
          ];
        };

        # My Lenovo Laptop (old)
        futaba = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./common.nix
            ./hosts/futaba/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };

                users.lia = import ./hosts/joker/home.nix;
              };
            }
          ];
        };

      };

    };
}
