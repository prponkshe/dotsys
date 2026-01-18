# devcontainer aliases
alias devup='devcontainer up --workspace-folder'

hx_into() {
  local c="$1"
  local tmp
  tmp="$(mktemp -d)"

  # Copy helix config while FOLLOWING symlinks (dereference)
  rsync -aL --delete "$HOME/.config/helix/" "$tmp/helix/"

  docker cp "$tmp/helix" "$c":/tmp/helix && \
  docker exec -it "$c" sh -lc '
    set -e
    mkdir -p ~/.config
    rm -rf ~/.config/helix
    mv /tmp/helix ~/.config/helix
  ' && \
  rm -rf "$tmp" && \
  docker exec -it "$c" env COLORTERM=truecolor TERM=xterm-256color bash
}

hx-cpp() {
  local c="$1"

  if [ -z "$c" ]; then
    echo "usage: hx-cpp <container>"
    return 1
  fi

  docker exec -it "$c" sh -lc '
    set -e

    # base deps
    apt-get update
    apt-get install -y software-properties-common curl ca-certificates gnupg

    # install clangd-21 (LLVM repo)
    if ! command -v clangd-21 >/dev/null 2>&1; then
      curl -fsSL https://apt.llvm.org/llvm.sh |  bash -s -- 21
       apt-get install -y clangd-21
    fi

    # make clangd-21 default
    if command -v update-alternatives >/dev/null 2>&1; then
       update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-21 100
       update-alternatives --set clangd /usr/bin/clangd-21
    else
       ln -sf /usr/bin/clangd-21 /usr/local/bin/clangd
    fi

    # install helix from PPA
    if ! command -v hx >/dev/null 2>&1; then
       add-apt-repository -y ppa:maveonair/helix-editor
       apt-get update
       apt-get install -y helix
    fi

    clangd --version
    hx --version
  '
}

dock() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: dock <container> [cpp]"
    return 1
  fi

  local container="$1"
  local mode="${2:-}"

  if [ "$mode" = "cpp" ]; then
    hx-cpp "$container" || return 1
  fi

  hx_into "$container"
}

_dock_complete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "$(docker ps --format '{{.Names}}')" -- "$cur") )
}

complete -F _dock_complete dock

# If wezterm set a dead SSH_AUTH_SOCK, fall back to system agent
if [[ "${TERM_PROGRAM:-}" == "WezTerm" ]] && [[ -n "${SSH_AUTH_SOCK:-}" ]] && [[ ! -S "${SSH_AUTH_SOCK}" ]]; then
  for s in \
    "$XDG_RUNTIME_DIR/ssh-agent.socket" \
    "$XDG_RUNTIME_DIR/ssh-agent" \
    "$XDG_RUNTIME_DIR/gcr/ssh" \
    "$XDG_RUNTIME_DIR/keyring/ssh" \
  ; do
    if [[ -S "$s" ]]; then
      export SSH_AUTH_SOCK="$s"
      break
    fi
  done
fi

