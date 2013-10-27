-module(rle).

-export([encode/1, decode/1]).

encode(L) -> encode(L, []).
encode([], Acc) -> {rle, lists:reverse(Acc)};
encode([H|T], []) ->
    encode(T, [{1, H}]);
encode([H|T], [{Count, Char}|AT]) ->
    if
        H =:= Char ->
            encode(T, [{Count + 1, Char}|AT]);
        true ->
            encode(T, [{1, H}|[{Count, Char}|AT]])
    end.

decode({rle, L}) -> lists:append(lists:reverse(decode(L, []))).
decode([], Acc) -> Acc;
decode([{Count, Char}|T], Acc) ->
    decode(T, [[Char || _ <- lists:seq(1, Count)]|Acc]).
