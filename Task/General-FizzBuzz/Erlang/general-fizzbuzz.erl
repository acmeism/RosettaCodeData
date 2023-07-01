%%% @doc Implementation of General FizzBuzz
%%% @see https://rosettacode.org/wiki/General_FizzBuzz
-module(general_fizzbuzz).
-export([run/2]).
-spec run(N :: pos_integer(), Factors :: list(tuple())) -> ok.

fizzbuzz(N, [], []) ->
    integer_to_list(N);
fizzbuzz(_, [], Result) ->
    lists:flatten(lists:reverse(Result));
fizzbuzz(N, Factors, Result) ->
    [{Factor, Output}|FactorsRest] = Factors,

    NextResult = case N rem Factor of
        0 -> [Output|Result];
        _ -> Result
    end,

    fizzbuzz(N, FactorsRest, NextResult).

run(N, Factors) ->
    lists:foreach(
        fun(S) -> io:format("~s~n", [S]) end,
        [fizzbuzz(X, Factors, []) || X <- lists:seq(1, N)]
    ).
