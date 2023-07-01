-module(combinations_permutations).

-export([test/0]).

perm(N, K) ->
    product(lists:seq(N - K + 1, N)).

comb(N, K) ->
    perm(N, K) div product(lists:seq(1, K)).

product(List) ->
    lists:foldl(fun(N, Acc) -> N * Acc end, 1, List).

test() ->
    io:format("\nA sample of permutations from 1 to 12:\n"),
    [show_perm({N, N div 3}) || N <- lists:seq(1, 12)],
    io:format("\nA sample of combinations from 10 to 60:\n"),
    [show_comb({N, N div 3}) || N <- lists:seq(10, 60, 10)],
    io:format("\nA sample of permutations from 5 to 15000:\n"),
    [show_perm({N, N div 3}) || N <- [5,50,500,1000,5000,15000]],
    io:format("\nA sample of combinations from 100 to 1000:\n"),
    [show_comb({N, N div 3}) || N <- lists:seq(100, 1000, 100)],
    ok.

show_perm({N, K}) ->
    show_gen(N, K, "perm", fun perm/2).

show_comb({N, K}) ->
    show_gen(N, K, "comb", fun comb/2).

show_gen(N, K, StrFun, Fun) ->
    io:format("~s(~p, ~p) = ~s\n",[StrFun, N, K, show_big(Fun(N, K), 40)]).

show_big(N, Limit) ->
    StrN = integer_to_list(N),
    case length(StrN) < Limit of
        true ->
            StrN;
        false ->
            {Shown, Hidden} = lists:split(Limit, StrN),
            io_lib:format("~s... (~p more digits)", [Shown, length(Hidden)])
    end.
