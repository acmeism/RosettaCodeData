lookandsay() {
    local num=$1 char seq i
    for ((i=0; i<=${#num}; i++)); do
        char=${num:i:1}
        if [[ $char == ${seq:0:1} ]]; then
            seq+=$char
        else
            [[ -n $seq ]] && printf "%d%s" ${#seq} ${seq:0:1}
            seq=$char
        fi
    done
}

for ((num=1, i=1; i<=10; i++)); do
    echo $num
    num=$( lookandsay $num )
done
