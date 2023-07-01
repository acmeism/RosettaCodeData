export LC_ALL=C
< /dev/urandom tr -cd '0-9' | fold -w 1 | jq -MRcnr -f 100-prisoners.jq
