{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    vim
    git
    gh
    ripgrep
    nil
    nixd
    nixpkgs-fmt
    nodejs
    gcc
    gd
    grim
    fuzzel
    clang-tools
    htop
    python314
    iftop
    below
    oxker
    vlc
    fd
    bat
    yazi
    dive
    wezterm
    zed-editor
  ];

  virtualisation.docker.enable = true;

  programs = {
    firefox.enable = true;

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
