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
    vulkan-tools
    alacritty
    inetutils
    black
    gh
    ncdu
    cloud-utils
    wl-clipboard
    obsidian
    ripgrep
    proton-pass
    jdk21
    bash-language-server
    basedpyright
    git-repo
    nil
    nixd
    zellij
    lshw
    nixpkgs-fmt
    nodejs_24
    gcc
    gd
    grim
    flameshot
    horst
    markdown-oxide
    gawk
    iputils
    gcc
    opencode
    helix
    dockerfile-language-server
    unzip
    wget
    xz
    zstd
    efitools
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
    swayfx
    pkgs-unstable.zed-editor
    sshpass
    curl
    tree-sitter
    lazygit
    lazyssh
    rustup
    cargo
    fzf
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.extraOptions = "--insecure-registry 10.10.0.105:5000 --insecure-registry localhost:5000";
  virtualisation.virtualbox.host.enable = true;

  programs = {
    firefox.enable = true;
    nix-ld.enable = true;
    zoxide.enable = true;
    npm.enable = true;

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
