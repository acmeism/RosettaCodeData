multisplit() {
    local str=$1
    shift
    local regex=$( IFS='|'; echo "$*" )
    local sep
    while [[ $str =~ $regex ]]; do
        sep=${BASH_REMATCH[0]}
        words+=( "${str%%${sep}*}" )
        seps+=( "$sep" )
        str=${str#*$sep}
    done
    words+=( "$str" )
}

words=() seps=()

original="a!===b=!=c"
recreated=""

multisplit "$original" "==" "!=" "="

for ((i=0; i<${#words[@]}; i++)); do
    printf 'w:"%s"\ts:"%s"\n' "${words[i]}" "${seps[i]}"
    recreated+="${words[i]}${seps[i]}"
done

if [[ $original == $recreated ]]; then
    echo "successfully able to recreate original string"
fi
