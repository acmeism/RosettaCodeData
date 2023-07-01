function emit_table {
    nameref d=$1
    typeset -i idx=0
    echo "<table>"
    emit_row th "" "${d[idx++][@]}"
    for (( ; idx<${#d[@]}; idx++ )); do
        emit_row td $idx "${d[idx][@]}"
    done
    echo "</table>"
}

function emit_row {
    typeset tag=$1; shift
    typeset row="<tr>"
    for elem; do
        row+=$(printf "<%s>%s</%s>" "$tag" "$elem" "${tag## *}")
    done
    row+="</tr>"
    echo "$row"
}

function addrow {
    nameref d=$1
    typeset n=${#d[@]}
    typeset -i i
    for ((i=0; i<$2; i++)); do
        d[n][i]=$(( $RANDOM % 10000 ))
    done
}

n=3
typeset -a data
data[0]=("X" "Y" "Z")
for i in {1..4}; do
    addrow data $n
done

emit_table data
