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

PS1='\[\e[1;38;2;127;187;179m\]\u \[\e[38;2;230;152;117m\]➤ \[\e[1;38;2;255;255;255m\]\w \[\e[38;2;167;192;128m\]$(parse_git_branch)\[\e[0m\] '
