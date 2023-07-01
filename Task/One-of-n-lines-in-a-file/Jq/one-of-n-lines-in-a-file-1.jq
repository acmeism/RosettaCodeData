export LC_ALL=C
< /dev/random tr -cd '0-9' | fold -w 4 | jq -Mnr -f program.jq
