if2() {
	if eval "$1"; then
		if eval "$2"; then eval "$3"; else eval "$4"; fi
	else
		if eval "$2"; then eval "$5"; else eval "$6"; fi
	fi
}
