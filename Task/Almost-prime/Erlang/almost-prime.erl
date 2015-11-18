-module(factors).
-export([factors/1,kfactors/0,kfactors/2]).

factors(N) ->
     factors(N,2,[]).

factors(1,_,Acc) -> Acc;
factors(N,K,Acc) when N rem K == 0 ->
    factors(N div K,K, [K|Acc]);
factors(N,K,Acc) ->
    factors(N,K+1,Acc).

kfactors() -> kfactors(10,5,1,1,[]).
kfactors(N,K) -> kfactors(N,K,1,1,[]).
kfactors(_Tn,Tk,_N,K,_Acc) when K == Tk+1 ->  io:fwrite("Done! ");
kfactors(Tn,Tk,N,K,Acc) when length(Acc) == Tn  ->
    io:format("K: ~w ~w ~n", [K, Acc]),
    kfactors(Tn,Tk,2,K+1,[]);

kfactors(Tn,Tk,N,K,Acc) ->
    case length(factors(N)) of K ->
     kfactors(Tn,Tk, N+1,K, Acc ++ [ N ] );
      _ ->
      kfactors(Tn,Tk, N+1,K, Acc) end.
