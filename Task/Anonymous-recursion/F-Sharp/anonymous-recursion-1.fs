let fib = function
    | n when n < 0 -> None
    | n -> let rec fib2 = function
               | 0 | 1 -> 1
               | n -> fib2 (n-1) + fib2 (n-2)
            in Some (fib2 n)
