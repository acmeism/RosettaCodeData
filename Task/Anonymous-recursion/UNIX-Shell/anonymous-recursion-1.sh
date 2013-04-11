fib() {
  if test 0 -gt "$1"; then
    echo "fib: fib of negative" 1>&2
    return 1
  else
    (
      fib2() {
        if test 2 -gt "$1"; then
          echo "$1"
        else
          echo $(( $(fib2 $(($1 - 1)) ) + $(fib2 $(($1 - 2)) ) ))
        fi
      }
      fib2 "$1"
    )
  fi
}
