set -- '' 13
res=''
while [ $# -ne 0 ]
do
    for d in 2 3 5 7
    do
        [ $d -ge $2 ] && {
            [ $d -eq $2 ] && res=$res${res:+ }$1$d
            break
        }
        set -- "$@" $1$d $(($2 - d))
    done
    shift 2
done
echo "$res"
