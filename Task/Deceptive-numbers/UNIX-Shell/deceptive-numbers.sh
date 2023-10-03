is () {
    return "$((!($1)))"
}

fermat_test () {
    set -- 1 "$1" "$(($2 - 1))" "$2"
    while is "$3 > 0"
    do
        set -- "$(($1 * (-($3 & 1) & ($2 ^ 1) ^ 1) % $4))" "$(($2 * $2 % $4))" "$(($3 >> 1))" "$4"
    done
    return "$(($1 != 1))"
}

set -- 7
c=0 n=$1
while :
do
    for w in 4 2 4 2 4 6 2 6
    do
        fermat_test 10 "$((n += w))" && for p
        do
            is 'p * p > n' && {
                set -- "$@" "$n"
                break
            }
            is 'n % p == 0' && {
                echo "$n"
                is '(c += 1) == 10' && exit
                break
            }
        done
    done
done
