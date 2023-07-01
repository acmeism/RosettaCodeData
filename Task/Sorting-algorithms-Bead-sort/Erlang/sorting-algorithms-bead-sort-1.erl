-module(beadsort).

-export([sort/1]).

sort(L) ->
	dist(dist(L)).

dist(L) when is_list(L) ->
	lists:foldl(fun (N, Acc) -> dist(Acc, N, []) end, [], L).

dist([H | T], N, Acc) when N > 0 ->
	dist(T, N - 1, [H + 1 | Acc]);
dist([], N, Acc) when N > 0 ->
	dist([], N - 1, [1 | Acc]);
dist([H | T], 0, Acc) ->
	dist(T, 0, [H | Acc]);
dist([], 0, Acc) ->
	lists:reverse(Acc).
