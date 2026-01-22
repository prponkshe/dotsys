{
  description = "NixOS Offline Auto Installer";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    dms.url = "github:AvengeMedia/DankMaterialShell";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      perSystem =
        {
          config,
          self',
          system,
          pkgs,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          devShells.default = pkgs.mkShell {
            packages = [ self'.formatter ];
          };

          packages = {
            default = config.packages.installer-iso;
            installer-iso = inputs.self.nixosConfigurations.installer.config.system.build.isoImage;
          };

          treefmt = {
            projectRootFile = "flake.lock";
            programs = {
              deadnix.enable = true;
              nixfmt.enable = true;
              shfmt.enable = true;
              statix.enable = true;
              prettier.enable = true;
            };
          };
        };
      flake = {
        nixosConfigurations =
          let
            inherit (inputs.nixpkgs.lib) genAttrs;
            mkVariant =
              name:
              inputs.nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [ ./configuration/variant/${name}.nix ];
              };
          in
          {
            installer = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [ ./installer.nix ];
            };
          }
          // genAttrs [ "thinkpad-p14s" "vivobook" ] mkVariant;
      };
    };
}
