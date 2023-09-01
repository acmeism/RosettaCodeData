set -- 2 1
x=-1
while [ $((x += 1)) -le 20 ]
do
        [ $x -gt $1 ] && set -- $(($2 + $1)) "$@"
        n=$x zeck=''
        for fib
        do
                zeck=$zeck$((n >= fib && (n -= fib) + 1))
        done
        echo "$x: ${zeck#0}"
done
