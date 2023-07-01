< /dev/urandom tr -cd '0-9' | fold -w 1 | jq -MRcnr -f program.jq
