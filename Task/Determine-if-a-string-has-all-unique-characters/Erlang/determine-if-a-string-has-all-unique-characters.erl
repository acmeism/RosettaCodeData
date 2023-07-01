-module(string_examples).
-export([all_unique/1, all_unique_examples/0]).

all_unique(String) ->
    CharPosPairs = lists:zip(String, lists:seq(1, length(String))),
    Duplicates = [{Char1, Pos1, Pos2} || {Char1, Pos1} <- CharPosPairs,
                                         {Char2, Pos2} <- CharPosPairs,
                                         Char1 =:= Char2,
                                         Pos2 > Pos1],
    case Duplicates of
        [] ->
            all_unique;
        [{Char, P1, P2}|_] ->
            {not_all_unique, Char, P1, P2}
    end.

all_unique_examples() ->
    lists:foreach(fun (Str) ->
                          io:format("String \"~ts\" (length ~p): ",
                                    [Str, length(Str)]),
                          case all_unique(Str) of
                              all_unique ->
                                  io:format("All characters unique.~n");
                              {not_all_unique, Char, P1, P2} ->
                                  io:format("First duplicate is '~tc' (0x~.16b)"
                                            " at positions ~p and ~p.~n",
                                            [Char, Char, P1, P2])
                          end
                  end,
                  ["", ".", "abcABC", "XYZ ZYX",
                   "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"]).
