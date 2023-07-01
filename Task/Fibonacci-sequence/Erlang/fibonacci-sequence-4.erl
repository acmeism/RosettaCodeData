fib(N) -> fib(N, 0, 1).

fib(0, Result, _Next) -> Result;
fib(Iter, Result, Next) -> fib(Iter-1, Next, Result+Next).
