# In case gojq is used, trim leading 0s:
function prng {
    cat /dev/urandom | tr -cd '0-9' | fold -w 10 | sed 's/^0*\(.*\)*\(.\)*$/\1\2/'
}

prng | jq -nMr -f program.jq
