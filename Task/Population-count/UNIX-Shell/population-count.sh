popcount() {
    local -i n=$1
    (( n < 0 )) && return 1
    local ones=0
    while (( n > 0 )); do
        (( ones += n%2 ))
        (( n /= 2 ))
    done
    echo $ones
}

popcount_3s=()
n=1
for (( i=0; i<30; i++ )); do
    popcount_3s+=( $(popcount $n) )
    (( n *= 3 ))
done
echo "powers of 3 popcounts: ${popcount_3s[*]}"

evil=()
odious=()
n=0
while (( ${#evil[@]} < 30 || ${#odious[@]} < 30 )); do
    p=$( popcount $n )
    if (( $p%2 == 0 )); then
        evil+=( $n )
    else
        odious+=( $n )
    fi
    (( n++ ))
done
echo "evil nums:   ${evil[*]:0:30}"
echo "odious nums: ${odious[*]:0:30}"
