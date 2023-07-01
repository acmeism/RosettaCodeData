-module(collatz).
-export([main/0,collatz/1,coll/1,max_atz_under/1]).

collatz(1) -> 1;
collatz(N) when N rem 2 == 0 -> 1 + collatz(N div 2);
collatz(N) when N rem 2 > 0 -> 1 + collatz(3 * N +1).

max_atz_under(N) ->
  F = fun (X) -> {collatz(X), X} end,
  {_, Index} = lists:max(lists:map(F, lists:seq(1, N))),
  Index.

coll(1) -> [1];
coll(N) when N rem 2 == 0 -> [N|coll(N div 2)];
coll(N) -> [N|coll(3 * N + 1)].

main() ->
    io:format("collatz(4) non-list total: ~w~n", [collatz(4)]),
    io:format("coll(4) with lists ~w~n",  [coll(4)] ),
    Seq27 = coll(27),
    Seq1000 = coll(max_atz_under(100000)),
    io:format("coll(27) length: ~B~n", [length(Seq27)]),
    io:format("coll(27) first 4: ~w~n", [lists:sublist(Seq27, 4)]),
    io:format("collatz(27) last 4: ~w~n",
              [lists:nthtail(length(Seq27) - 4, Seq27)]),
    io:format("maximum  N <= 100000..."),
    io:format("Max: ~w~n", [max_atz_under(100000)]),
    io:format("Total: ~w~n", [ length( Seq1000 ) ] ).
