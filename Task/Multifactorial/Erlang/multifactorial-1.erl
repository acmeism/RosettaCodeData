-module(multifac).
-compile(export_all).

multifac(N,D) ->
    lists:foldl(fun (X,P) -> X * P end, 1, lists:seq(N,1,-D)).

main() ->
    Ds = lists:seq(1,5),
    Ns = lists:seq(1,10),
    lists:foreach(fun (D) ->
                          io:format("Degree ~b: ~p~n",[D, [ multifac(N,D) || N <- Ns]])
                  end, Ds).
