fib := method(x,
    if(x < 0, Exception raise("Negative argument not allowed!"))
    fib2 := method(n,
        if(n < 2, n, fib2(n-1) + fib2(n-2))
    )
    fib2(x floor)
)
