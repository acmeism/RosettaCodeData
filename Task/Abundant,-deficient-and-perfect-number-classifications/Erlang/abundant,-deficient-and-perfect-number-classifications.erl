-module(properdivs).
-export([divs/1,sumdivs/1,class/1]).

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

class(Limit) -> class(0,0,0,sumdivs(2),2,Limit).

class(D,P,A,_Sum,Acc,L) when Acc > L +1->
    io:format("Deficient: ~w, Perfect: ~w, Abundant: ~w~n", [D,P,A]);

class(D,P,A,Sum,Acc,L) when Acc < Sum ->
       class(D,P,A+1,sumdivs(Acc+1),Acc+1,L);
class(D,P,A,Sum,Acc,L) when Acc == Sum ->
       class(D,P+1,A,sumdivs(Acc+1),Acc+1,L);
class(D,P,A,Sum,Acc,L) when Acc > Sum  ->
       class(D+1,P,A,sumdivs(Acc+1),Acc+1,L).
