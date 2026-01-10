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
