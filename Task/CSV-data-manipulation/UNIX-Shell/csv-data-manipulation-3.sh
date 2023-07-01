bash>exec 0<"$1"                 # open the input file on stdin
exec 1>"$1.new"             # open an output file on stdout
{
    read -r header
    echo "$header,SUM"
    IFS=,
    while read -r -a numbers; do
        sum=0
        for num in "${numbers[@]}"; do
            (( sum += num ))
        done

        # can write the above loop as
        #   sum=$(( $(IFS=+; echo "${numbers[*]}") ))

        echo "${numbers[*]},$sum"
    done
} &&
mv "$1" "$1.bak" &&
mv "$1.new" "$1"
