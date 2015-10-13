-module(factors).
-export([factors/1,kthfactor/2]).

factors(N) ->
     factors(N,2,[]).

factors(1,_,Acc) -> Acc;
factors(N,K,Acc) when N rem K == 0 ->
%    io:format("Ks: ~w~n", [[K|Acc]]),
    factors(N div K,K, [K|Acc]);
factors(N,K,Acc) ->
    factors(N,K+1,Acc).


% is integer N factorable into M primes?
kthfactor(N,M) ->
    case length(factors(N)) of M ->
      factors(N);
      _ ->
      false end.
