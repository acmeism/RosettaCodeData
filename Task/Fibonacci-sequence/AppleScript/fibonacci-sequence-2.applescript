on fib(n)
    if n < 1 then
        0
    else if n < 3 then
        1
    else
        fib(n - 2) + fib(n - 1)
    end if
end fib
