-module(divs).
-export([divs/1]).

divs(0) -> [];
divs(1) -> [];
divs(N) -> lists:sort(divisors(1,N))++[N].

divisors(1,N) ->
     [1] ++ divisors(2,N,math:sqrt(N)).

divisors(K,_N,Q) when K > Q -> [];
divisors(K,N,_Q) when N rem K =/= 0 ->
    [] ++ divisors(K+1,N,math:sqrt(N));
divisors(K,N,_Q) when K * K  == N ->
    [K] ++ divisors(K+1,N,math:sqrt(N));
divisors(K,N,_Q) ->
    [K, N div K] ++ divisors(K+1,N,math:sqrt(N)).
