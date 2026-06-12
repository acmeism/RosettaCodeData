load "stdlibcore.ring"
see "working..." + nl
num = 0

see  "The first 9 Prime Fibonacci numbers: " + nl
for n = 1 to 1000000
     x = fib(n)
     if isprime(x)
        num++
        if num< 10
           ?  "" + x + "  "
        else
           exit
        ok
     ok
next

see "done..." + nl

func fib nr
       if nr = 0 return 0 ok
       if nr = 1 return 1 ok
       if nr > 1 return fib(nr-1) + fib(nr-2) ok
