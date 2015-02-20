get_nth_line() {
    local file=$1 n=$2 line
    while ((n-- > 0)); do
        if ! IFS= read -r line; then
            echo "No such line $2 in $file"
            return 1
        fi
    done < "$file"
    echo "$line"
}

get_nth_line filename 7
