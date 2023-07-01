queue_push() {
    typeset -n q=$1
    shift
    q+=("$@")
}

queue_pop() {
    if queue_empty $1; then
        print -u2 "queue $1 is empty"
        return 1
    fi
    typeset -n q=$1
    print "${q[0]}"     # emit the value of the popped element
    q=( "${q[@]:1}" )   # and remove the first element from the queue
}

queue_empty() {
    typeset -n q=$1
    (( ${#q[@]} == 0 ))
}

queue_peek() {
    typeset -n q=$1
    print "${q[0]}"
}
