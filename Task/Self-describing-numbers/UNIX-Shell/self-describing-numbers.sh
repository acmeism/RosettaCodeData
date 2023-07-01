selfdescribing() {
    local n=$1
    local count=()
    local i
    for ((i=0; i<${#n}; i++)); do
        ((count[${n:i:1}]++))
    done
    for ((i=0; i<${#n}; i++)); do
        (( ${n:i:1} == ${count[i]:-0} )) || return 1
    done
    return 0
}

for n in 0 1 10 11 1210 2020 21200 3211000 42101000; do
    if selfdescribing $n; then
        printf "%d\t%s\n" $n yes
    else
        printf "%d\t%s\n" $n no
    fi
done
