fib() {
  local n=$1
  [ $n -lt 2 ] && echo -n $n || echo -n $(( $( fib $(( n - 1 )) ) + $( fib $(( n - 2 )) ) ))
}
