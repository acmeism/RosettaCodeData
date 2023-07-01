-module(list_sum).
-export([sum_rec/1, sum_tail/1]).

% recursive definition:
sum_rec([]) ->
    0;
sum_rec([Head|Tail]) ->
    Head + sum_rec(Tail).

% tail-recursive definition:
sum_tail(L) ->
    sum_tail(L, 0).
sum_tail([], Acc) ->
    Acc;
sum_tail([Head|Tail], Acc) ->
    sum_tail(Tail, Head + Acc).
