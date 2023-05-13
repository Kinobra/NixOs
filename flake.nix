{
  # Description, write anything or even nothing
  description = "sntx's NixOS flake";

  # Input config, or package repos
  inputs = {
    # Nixpkgs, NixOS's official repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Output config, or config for NixOS system
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # You can define many systems in one Flake file.
    # NixOS will choose one based on your hostname.

    # Personal list of possible secondary system names:
    # Juno, Vesta, Minerva, Ceres, Diana, Venus,
    # Mars, Mercurius, Iovis, Neptunus, Vulcanus, Apollo

    # Define a system called "minerva"
    nixosConfigurations."ceres" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        (import ./modules)
        {
          networking.domain = "";
          networking.hostName = "ceres";
          myProfiles.server-minimal.enable = true;
          myHardware.ceres.enable = true;
        }
      ];
    };

    # Define a system called "minerva"
    nixosConfigurations."minerva" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        (import ./modules)
        {
          networking.hostName = "minerva";
          myDesktops.sway.enable = true;
          myProfiles.desktop-minimal.enable = true;
          myHardware.minerva.enable = true;
          myThemes.sagittarius-a-star.enable = true;
        }
      ];
    };

    # Define a primary system called "nixos"
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        (import ./modules)
        {
          networking.hostName = "nixos";
          myDesktops.sway.enable = true;
          myProfiles.desktop.enable = true;
          myHardware.nixos.enable = true;
          myThemes.sagittarius-a-star.enable = true;
        }
      ];
    };
  };
}
