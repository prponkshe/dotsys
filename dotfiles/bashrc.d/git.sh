parse_git_branch() {
	git rev-parse --is-inside-work-tree &>/dev/null || return

	branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
	echo_str=" ($branch"

	upstream=$(git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>/dev/null)
	if [ $? -eq 0 ]; then
		read ahead behind <<< $(git rev-list --left-right --count "$branch...$upstream" 2>/dev/null)
	if [ "$ahead" -gt 0 ]; then
	    echo_str+=" ⇡$ahead"
	fi
	if [ "$behind" -gt 0 ]; then
	    echo_str+=" ⇣$behind"
	fi
	fi

	echo "$echo_str)"
}


PS1='\[\e[94m\]\u\[\e[38;2;204;102;0m\]➤ \[\e[93m\]\w\[\e[92m\]$(parse_git_branch)\[\e[0m\]\$ '

