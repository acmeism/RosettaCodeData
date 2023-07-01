is_repeated() {
    local str=$1 len rep part
    for (( len = ${#str} / 2; len > 0; len-- )); do
        part=${str:0:len}
        rep=""
        while (( ${#rep} < ${#str} )); do
            rep+=$part
        done
        if [[ ${rep:0:${#str}} == $str ]] && (( $len < ${#str} )); then
            echo "$part"
            return 0
        fi
    done
    return 1
}

while read test; do
    if part=$( is_repeated "$test" ); then
        echo "$test is composed of $part repeated"
    else
        echo "$test is not a repeated string"
    fi
done <<END_TESTS
1001110011
1110111011
0010010010
1010101010
1111111111
0100101101
0100100
101
11
00
1
END_TESTS
