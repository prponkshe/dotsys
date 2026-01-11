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
in
{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    vim
    git
    alacritty
    gh
    ripgrep
    nil
    nixd
    lshw
    nixpkgs-fmt
    virtualgl
    nodejs_24
    pkgs-unstable.codex
    gcc
    gd
    grim
    fuzzel
    clang-tools
    htop
    python314
    iftop
    below
    devpod
    oxker
    vlc
    fd
    bat
    yazi
    xhost
    unzip
    zip
    gnutar
    dive
    wezterm
    zed-editor
    curl
    tree-sitter
    lazygit
    fzf
  ];

  virtualisation.docker.enable = true;

  programs = {
    firefox.enable = true;
    nix-ld.enable = true;
    zoxide.enable = true;
    npm.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };

    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
      };
    };

    bash = {
      enable = true;
      promptInit = ''
        # Source ~/.bashrc.d/*
        if [ -d "$HOME/.bashrc.d" ]; then
          for rc in "$HOME"/.bashrc.d/*; do
            [ -f "$rc" ] && . "$rc"
          done
        fi
        unset rc
      '';
    };
  };
}
