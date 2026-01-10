{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../modules/configuration.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  networking.hostName = "northee-ltp";

  services = {
    libinput.enable = true;
    openssh.enable = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.northee = {
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

  home-manager.users.northee = {
    imports = [ ../modules/home.nix ];
    _module.args = {
      username = "northee";
      homeDirectory = config.users.users.northee.home;
    };
  };
}
