p() { [ $# -eq 0 ] && echo || (shift; p "$@") | while read r ; do echo -e "$1 $r\n$r"; done }
