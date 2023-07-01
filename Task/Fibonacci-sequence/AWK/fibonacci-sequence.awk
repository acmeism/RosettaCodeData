$ awk 'func fib(n){return(n<2?n:fib(n-1)+fib(n-2))}{print "fib("$1")="fib($1)}'
10
fib(10)=55
