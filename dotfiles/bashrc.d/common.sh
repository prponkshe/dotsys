alias bots='sshpass -p Nimda#321 ssh local@10.10.0.105'

# Terminal
alias v='nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias c='clear'
alias penv='source ~/.venv/bin/activate'
alias catp='xclip -selection clipboard <'

# Kill Program
alias killp='f(){ pids=$(pgrep -i -f "$1"); [ -n "$pids" ] && sudo kill $pids; }; f'

# Editor
alias devzed='devpod up . --ide zed && exit'

# System
alias my='sudo chown -R $(whoami):users .'
alias duh='du -sh *' # Human-readable directory sizes
alias mirror='xrandr --output HDMI-1 --same-as eDP-1 --mode 1920x1080'

mdrive() {
    mkdir -p ~/ponkshedrive
    local share="$1" # Share name
    sudo mount -t cifs -o user=pado //ponkshedrive/"$share" ~/ponkshedrive
}

# Copying and Sorting
alias cp%='rsync -a --info=progress2'
alias deldupe='rdfind -deleteduplicates true'

# Compression
alias untar='tar -xvzf'

mkcd() {
    local folder="$1" # Folder name
    mkdir $folder && cd $folder
}

# Networking
# Usage: share_internet <MY_IP> <PEER_IP>
# Example: share_internet 193.193.193.5 193.193.193.2
share_internet() {
    local MY_IP="$1"
    local PEER_IP="$2"
    local ETH_IF="enp0s31f6"

    if [ -z "$MY_IP" ] || [ -z "$PEER_IP" ]; then
        echo "Usage: share_internet <MY_IP> <PEER_IP>"
        return 2
    fi

    # find outgoing interface from default route (the Wi-Fi interface carrying internet)
    local OUT_IF
    OUT_IF=$(ip route get 8.8.8.8 2>/dev/null | awk '/dev/ {for(i=1;i<=NF;i++) if($i=="dev") {print $(i+1); exit}}')

    if [ -z "$OUT_IF" ]; then
        echo "ERROR: could not determine outgoing interface (no default route)."
        return 3
    fi

    echo "Bringing up $ETH_IF with $MY_IP (peer: $PEER_IP). Outbound iface: $OUT_IF"

    # add address to ethernet interface; if add fails (address exists), try replace
    if ! sudo ip addr add "${MY_IP}/24" dev "$ETH_IF" 2>/dev/null; then
        echo "ip addr add failed; attempting ip addr replace"
        sudo ip addr replace "${MY_IP}/24" dev "$ETH_IF" || {
            echo "ERROR: failed to set IP on $ETH_IF"
            return 4
        }
    fi

    # bring link up
    sudo ip link set dev "$ETH_IF" up || {
        echo "ERROR: failed to bring $ETH_IF up"
        return 5
    }

    # Clear any identical nat/forward rules we may have added previously to avoid duplicates
    # (safe: ignore failures)
    sudo iptables -t nat -D POSTROUTING -o "$OUT_IF" -j MASQUERADE 2>/dev/null || true
    sudo iptables -D FORWARD -i "$OUT_IF" -o "$ETH_IF" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
    sudo iptables -D FORWARD -i "$ETH_IF" -o "$OUT_IF" -j ACCEPT 2>/dev/null || true

    # Add NAT (masquerade) and forwarding rules
    sudo iptables -t nat -A POSTROUTING -o "$OUT_IF" -j MASQUERADE ||
        {
            echo "ERROR: failed to add POSTROUTING MASQUERADE"
            return 6
        }

    sudo iptables -A FORWARD -i "$OUT_IF" -o "$ETH_IF" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT ||
        {
            echo "ERROR: failed to add FORWARD for established connections"
            return 7
        }

    sudo iptables -A FORWARD -i "$ETH_IF" -o "$OUT_IF" -j ACCEPT ||
        {
            echo "ERROR: failed to add FORWARD from $ETH_IF to $OUT_IF"
            return 8
        }

    echo "NAT rules applied. On the peer ($PEER_IP) set default gateway to $MY_IP and configure DNS (e.g. 1.1.1.1)."
    echo "Note: rules are not persistent across reboot."
}

sort_media() {
    local depth=$1

    if [[ "$depth" != "1" && "$depth" != "2" && "$depth" != "3" ]]; then
        echo "Usage: sort_media_by_depth <1|2|3>"
        return 1
    fi

    shopt -s nocaseglob

    for file in *; do
        if [[ -f "$file" ]]; then
            ext="${file##*.}"
            case "$ext" in
            jpg | jpeg | png | gif | bmp | tiff | heic | webp)
                media_type="Images"
                ;;
            mp4 | mkv | mov | avi | flv | wmv | webm)
                media_type="Videos"
                ;;
            *)
                continue
                ;;
            esac

            # Get modified date info
            year=$(date -r "$file" +%Y)
            month=$(date -r "$file" +%m)
            month_name=$(date -r "$file" +%B)

            # Determine target directory based on depth
            case "$depth" in
            1)
                target_dir="$media_type"
                ;;
            2)
                target_dir="$media_type/$year"
                ;;
            3)
                target_dir="$media_type/$year/$month_name"
                ;;
            esac

            mkdir -p "$target_dir"
            mv -- "$file" "$target_dir/"
        fi
    done

    shopt -u nocaseglob
}

# System Task Assign Cores
cores() {
    # Check if there are at least 2 arguments
    if [ "$#" -lt 2 ]; then
        echo "Usage: $0 <command>... <num_cores>"
        exit 1
    fi

    # Extract number of cores (last argument)
    NUM_CORES="${!#}"

    # Validate NUM_CORES is a positive integer
    if ! [[ "$NUM_CORES" =~ ^[0-9]+$ ]] || [ "$NUM_CORES" -eq 0 ]; then
        echo "Error: The last argument must be a positive integer for number of cores."
        exit 1
    fi

    # Extract the command (all but the last argument)
    COMMAND=("${@:1:$#-1}")

    # Build CPU mask (for CPUs 0 to NUM_CORES-1)
    CPU_MASK=0
    for ((i = 0; i < NUM_CORES; i++)); do
        CPU_MASK=$((CPU_MASK | (1 << i)))
    done

    # Convert mask to hex
    CPU_MASK_HEX=$(printf '%x' "$CPU_MASK")

    # Run the command with taskset
    echo "Running: ${COMMAND[*]} on CPUs 0 to $((NUM_CORES - 1)) with mask 0x$CPU_MASK_HEX"
    taskset 0x$CPU_MASK_HEX "${COMMAND[@]}"
}
