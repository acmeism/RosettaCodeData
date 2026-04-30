fib: func [n /f][ do f: func [m] [ either m < 2 [m][(f m - 1) + f m - 2]] n]
