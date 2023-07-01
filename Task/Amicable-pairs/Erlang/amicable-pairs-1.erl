-module(properdivs).
-export([amicable/1,divs/1,sumdivs/1]).

amicable(Limit) -> amicable(Limit,[],3,2).

amicable(Limit,List,_Current,Acc) when Acc >= Limit -> List;
amicable(Limit,List,Current,Acc) when Current =< Acc/2  ->
    amicable(Limit,List,Acc,Acc+1);
amicable(Limit,List,Current,Acc) ->
    CS = sumdivs(Current),
    AS = sumdivs(Acc),
    if
        CS == Acc andalso AS == Current andalso Acc =/= Current ->
          io:format("A: ~w, B: ~w, ~nL: ~w~w~n",  [Current,Acc,divs(Current),divs(Acc)]),
          NL = List ++ [{Current,Acc}],
          amicable(Limit,NL,Acc+1,Acc+1);
        true ->
          amicable(Limit,List,Current-1,Acc) end.

divs(0) -> [];
divs(1) -> [];
divs(N) -> lists:sort(divisors(1,N)).

divisors(1,N) ->
     [1] ++ divisors(2,N,math:sqrt(N)).

divisors(K,_N,Q) when K > Q -> [];
divisors(K,N,_Q) when N rem K =/= 0 ->
    [] ++ divisors(K+1,N,math:sqrt(N));
divisors(K,N,_Q) when K * K  == N ->
    [K] ++ divisors(K+1,N,math:sqrt(N));
divisors(K,N,_Q) ->
    [K, N div K] ++ divisors(K+1,N,math:sqrt(N)).

sumdivs(N) -> lists:sum(divs(N)).
