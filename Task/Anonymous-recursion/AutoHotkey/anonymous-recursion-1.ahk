fib(n)
{       if(n < 0)
                return error
        else if(n < 2)
                return 1
        else
                return n * fib(n-1)
}
