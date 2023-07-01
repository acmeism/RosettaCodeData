str="WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
enc=$(encode "$str")
dec=$(decode "$enc")
declare -p str enc dec
[[ $str == "$dec" ]] && echo success || echo failure
