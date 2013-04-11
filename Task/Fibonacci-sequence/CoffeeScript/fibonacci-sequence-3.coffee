fib_rec = (n) ->
    if n < 2
        return n
    else
        return fib_rec(n-1) + fib_rec(n-2)
