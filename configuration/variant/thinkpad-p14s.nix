{
  config,
  pkgs,
  inputs,
  ...
}:

let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config = config.nixpkgs.config; # carries allowUnfree, etc.
  };
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../modules/configuration.nix
  ];

  environment.systemPackages = with pkgs; [
      pkgs-unstable.foxglove-studio
  ];

  networking.hostName = "ATL-HPLT-326";

  services = {
    libinput.enable = true;
    openssh.enable = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prponkshe = {
    isNormalUser = true;
    description = "Pradyumna Ponkshe";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.extraSpecialArgs = {
    inherit inputs;
  };

  home-manager.users.prponkshe = {
    imports = [ ../modules/home.nix ];
    _module.args = {
      username = "prponkshe";
      homeDirectory = config.users.users.prponkshe.home;
    };
  };
}
