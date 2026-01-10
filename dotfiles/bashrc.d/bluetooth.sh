c-jbl() {
	rfkill unblock bluetooth
	bluetoothctl power on && bluetoothctl connect 70:50:E7:70:75:D8
    exit
}

alias d-jbl='bluetoothctl power off'
