function replace {
    typeset search=$1 replace=$2
    typeset file lines line
    shift 2
    for file in "$@"; do
        lines=()
        while IFS= read -r line; do
            lines+=( "${line//$search/$replace}" )
        done < "$file"
        printf "%s\n" "${lines[@]}" > "$file"
    done
}
replace "Goodbye London!" "Hello New York!" a.txt b.txt c.txt
