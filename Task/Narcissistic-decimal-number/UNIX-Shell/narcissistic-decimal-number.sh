function narcissistic {
    integer n=$1 len=${#n} sum=0 i
    for ((i=0; i<len; i++)); do
        (( sum += pow(${n:i:1}, len) ))
    done
    (( sum == n ))
}

nums=()
for ((n=0; ${#nums[@]} < 25; n++)); do
    narcissistic $n && nums+=($n)
done
echo "${nums[*]}"
echo "elapsed: $SECONDS"
