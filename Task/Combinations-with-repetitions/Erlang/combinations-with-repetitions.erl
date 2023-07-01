-module(comb).
-compile(export_all).

comb_rep(0,_) ->
    [[]];
comb_rep(_,[]) ->
    [];
comb_rep(N,[H|T]=S) ->
    [[H|L] || L <- comb_rep(N-1,S)]++comb_rep(N,T).
