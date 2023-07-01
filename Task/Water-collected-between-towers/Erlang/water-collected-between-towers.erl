-module(watertowers).
-export([towers/1, demo/0]).

towers(List) -> element(2, tower(List, 0)).

tower([], _) -> {0,0};
tower([H|T], MaxLPrev) ->
    MaxL = max(MaxLPrev, H),
    {MaxR, WaterAcc} = tower(T, MaxL),
    {max(MaxR,H), WaterAcc+max(0, min(MaxR,MaxL)-H)}.

demo() ->
    Cases = [[1, 5, 3, 7, 2],
             [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
             [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
             [5, 5, 5, 5],
             [5, 6, 7, 8],
             [8, 7, 7, 6],
             [6, 7, 10, 7, 6]],
    [io:format("~p -> ~p~n", [Case, towers(Case)]) || Case <- Cases],
    ok.
