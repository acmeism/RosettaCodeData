function entropy {
    typeset -i i len=${#1}
    typeset -X13 r=0
    typeset -Ai counts

    for ((i = 0; i < len; ++i))
    do
        counts[${1:i:1}]+=1
    done
    for i in "${counts[@]}"
    do
        r+='i * log2(i)'
    done
    r='log2(len) - r / len'
    print -r -- "$r"
}

printf '%g\n' "$(entropy '1223334444')"
