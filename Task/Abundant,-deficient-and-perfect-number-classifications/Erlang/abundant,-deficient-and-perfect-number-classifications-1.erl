-module(properdivs).
-export([divs/1,sumdivs/1,class/1]).

divs(0) -> [];
divs(1) -> [];
divs(N) -> lists:sort(divisors(1,N)).

divisors(1,N) ->
      divisors(2,N,math:sqrt(N),[1]).

divisors(K,_N,Q,L) when K > Q -> L;
divisors(K,N,_Q,L) when N rem K =/= 0 ->
    divisors(K+1,N,_Q,L);
divisors(K,N,_Q,L) when K * K  =:= N ->
    divisors(K+1,N,_Q,[K|L]);
divisors(K,N,_Q,L) ->
    divisors(K+1,N,_Q,[N div K, K|L]).

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
