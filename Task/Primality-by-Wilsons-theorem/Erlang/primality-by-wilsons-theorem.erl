#! /usr/bin/escript

isprime(N) when N < 2 -> false;
isprime(N) when N band 1 =:= 0 -> N =:= 2;
isprime(N) -> fac_mod(N - 1, N) =:= N - 1.

fac_mod(N, M) -> fac_mod(N, M, 1).
fac_mod(1, _, A) -> A;
fac_mod(N, M, A) -> fac_mod(N - 1, M, A*N rem M).

main(_) ->
    io:format("The first few primes (via Wilson's theorem) are: ~n~p~n",
              [[K || K <- lists:seq(1, 128), isprime(K)]]).
