-module(quickselect).

-export([test/0]).


test() ->
    V = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4],
    lists:map(
        fun(I) -> quickselect(I,V) end,
        lists:seq(0, length(V) - 1)
    ).

quickselect(K, [X | Xs]) ->
    {Ys, Zs} =
        lists:partition(fun(E) -> E < X end, Xs),
    L = length(Ys),
    if
        K < L ->
            quickselect(K, Ys);
        K > L ->
            quickselect(K - L - 1, Zs);
        true ->
            X
    end.
