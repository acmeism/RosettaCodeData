-module(properdivs).
-export([divs/1,sumdivs/1,longest/1]).

divs(0) -> [];
divs(1) -> [];
divs(N) -> lists:sort([1] ++ divisors(2,N,math:sqrt(N))).

divisors(K,_N,Q) when K > Q -> [];
divisors(K,N,Q) when N rem K =/= 0 ->
    divisors(K+1,N,Q);
divisors(K,N,Q) when K * K  == N ->
    [K] ++ divisors(K+1,N,Q);
divisors(K,N,Q) ->
    [K, N div K] ++ divisors(K+1,N,Q).

sumdivs(N) -> lists:sum(divs(N)).

longest(Limit) -> longest(Limit,0,0,1).

longest(L,Current,CurLeng,Acc) when Acc >= L ->
    io:format("With ~w, Number ~w has the most divisors~n", [CurLeng,Current]);
longest(L,Current,CurLeng,Acc) ->
    A = length(divs(Acc)),
    if A > CurLeng ->
        longest(L,Acc,A,Acc+1);
        true -> longest(L,Current,CurLeng,Acc+1)
    end.
