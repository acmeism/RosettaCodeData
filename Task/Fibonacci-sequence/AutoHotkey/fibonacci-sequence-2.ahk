/*
Important note: the recursive version would be very slow
without a global or static array. The iterative version
handles also negative arguments properly.
*/

FibR(n) {       ; n-th Fibonacci number (n>=0, recursive with static array Fibo)
   Static
   Return n<2 ? n : Fibo%n% ? Fibo%n% : Fibo%n% := FibR(n-1)+FibR(n-2)
}

Fib(n) {        ; n-th Fibonacci number (n < 0 OK, iterative)
   a := 0, b := 1
   Loop % abs(n)-1
      c := b, b += a, a := c
   Return n=0 ? 0 : n>0 || n&1 ? b : -b
}
