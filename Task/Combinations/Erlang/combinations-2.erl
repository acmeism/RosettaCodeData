-module(comb).
-export([combinations/2]).

combinations(K, List) ->
    lists:last(all_combinations(K, List)).

all_combinations(K, List) ->
    lists:foldr(
      fun(X, Next) ->
              Sub = lists:sublist(Next, length(Next) - 1),
              Step = [[]] ++ [[[X|S] || S <- L] || L <- Sub],
              lists:zipwith(fun lists:append/2, Step, Next)
      end, [[[]]] ++ lists:duplicate(K, []), List).
