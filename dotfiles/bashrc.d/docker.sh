dock() {
  if [ -z "$1" ]; then
    echo "Usage: dock <container_name>"
    return 1
  fi
  docker exec -it "$1" bash
}

_dock_complete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "$(docker ps --format '{{.Names}}')" -- "$cur") )
}

complete -F _dock_complete dock

# If wezterm set a dead SSH_AUTH_SOCK, fall back to system agent
if [[ "${TERM_PROGRAM:-}" == "WezTerm" ]] && [[ -n "${SSH_AUTH_SOCK:-}" ]] && [[ ! -S "${SSH_AUTH_SOCK}" ]]; then
  for s in \
    "$XDG_RUNTIME_DIR/gcr/ssh" \
    "$XDG_RUNTIME_DIR/keyring/ssh" \
    "$XDG_RUNTIME_DIR/ssh-agent.socket" \
    "$XDG_RUNTIME_DIR/ssh-agent" \
  ; do
    if [[ -S "$s" ]]; then
      export SSH_AUTH_SOCK="$s"
      break
    fi
  done
fi

