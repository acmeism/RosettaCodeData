fib(N) -> fib(N,0,1).
fib(0,Res,_) -> Res;
fib(N,Res,Next) when N > 0 -> fib(N-1, Next, Res+Next).
