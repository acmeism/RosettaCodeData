-module(fiblin).
-export([fib/1])

fib(0) -> 0;
fib(1) -> 1;
fib(2) -> 1;
fib(3) -> 2;
fib(4) -> 3;
fib(5) -> 5;

fib(N) when is_integer(N) -> fib(N - 6, 5, 8).
fib(N, A, B) -> if N < 1 -> B; true -> fib(N-1, B, A+B) end.
