typeset -A hash
hash=( [key1]=val1 [key2]=val2 )
hash[key3]=val3
echo "${hash[key3]}"
