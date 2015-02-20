assert() {
    if test ! $1; then
        [[ $2 ]] && echo "$2" >&2
        exit 1
    fi
}
x=42
assert "$x -eq 42" "that's not the answer"
((x--))
assert "$x -eq 42" "that's not the answer"
echo "won't get here"
