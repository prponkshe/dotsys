{
  config,
  username,
  ...
}:

let
  dotfiles = "/home/${username}/dotsys/dotfiles";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    niri = "niri";
    zed = "zed";
    alacritty = "alacritty";
    backgrounds = "backgrounds";
    i3 = "i3";
    polybar = "polybar";
    noctalia = "noctalia";
    wezterm = "wezterm";
    sway = "sway";
    helix = "helix";
    flameshot = "flameshot";
  };
in
{
  ############################
  # Required
  ############################
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11"; # DO NOT change casually

  ############################
  # Bash Setup
  ############################
  home.file.".bashrc.d".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/bashrc.d";

  ############################
  # XDG dotfiles
  ############################
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
