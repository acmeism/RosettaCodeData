proto fib (Int $n --> Int) is cached {*}
multi fib (0)  { 0 }
multi fib (1)  { 1 }
multi fib ($n) { fib($n - 1) + fib($n - 2) }
