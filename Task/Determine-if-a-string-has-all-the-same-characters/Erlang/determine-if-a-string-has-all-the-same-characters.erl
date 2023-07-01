-module(string_examples).
-export([examine_all_same/1, all_same_examples/0]).

all_same_characters([], _Offset) ->
    all_same;
all_same_characters([_], _Offset) ->
    all_same;
all_same_characters([X, X | Rest], Offset) ->
    all_same_characters([X | Rest], Offset + 1);
all_same_characters([X, Y | _Rest], Offset) when X =/= Y ->
    {not_all_same, Y, Offset + 1}.

examine_all_same(String) ->
    io:format("String \"~ts\" of length ~p:~n", [String, length(String)]),
    case all_same_characters(String, 0) of
        all_same ->
            io:format("  All characters are the same.~n~n");
        {not_all_same, OffendingChar, Offset} ->
            io:format("  Not all characters are the same.~n"),
            io:format("  Char '~tc' (0x~.16b) at offset ~p differs.~n~n",
                      [OffendingChar, OffendingChar, Offset])
    end.

all_same_examples() ->
    Strings = ["",
               "   ",
               "2",
               "333",
               ".55",
               "tttTTT",
               "4444 444k",
               "pépé",
               "🐶🐶🐺🐶",
               "🎄🎄🎄🎄"],
    lists:foreach(fun examine_all_same/1, Strings).
