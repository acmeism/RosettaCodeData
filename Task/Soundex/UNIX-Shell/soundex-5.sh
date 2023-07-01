declare -A tests=(
    [Soundex]=S532     [Example]=E251      [Sownteks]=S532   [Ekzampul]=E251
    [Euler]=E460       [Gauss]=G200        [Hilbert]=H416    [Knuth]=K530
    [Lloyd]=L300       [Lukasiewicz]=L222  [Ellery]=E460     [Ghosh]=G200
    [Heilbronn]=H416   [Kant]=K530         [Ladd]=L300       [Lissajous]=L222
    [Wheaton]=W350     [Burroughs]=B620    [Burrows]=B620    ["O'Hara"]=O600
    [Washington]=W252  [Lee]=L000          [Gutierrez]=G362  [Pfister]=P236
    [Jackson]=J250     [Tymczak]=T522      [VanDeusen]=V532  [Ashcraft]=A261
)

run_tests() {
    local func=$1
    echo "Testing with function $func"
    local -i all=0 fail=0
    for name in "${!tests[@]}"; do
        s=$($func "$name")
        if [[ $s != "${tests[$name]}" ]]; then
            echo "FAIL - $s - $name -- EXPECTING ${tests[$name]}"
            ((fail++))
        fi
        ((all++))
    done
    echo "$fail out of $all failures"
}

run_tests soundex
run_tests soundex2
run_tests soundex3
