-module(rle).

-export([encode/1,decode/1]).

-include_lib("eunit/include/eunit.hrl").

encode(S) ->
    doEncode(string:substr(S, 2), string:substr(S, 1, 1), 1, []).

doEncode([], CurrChar, Count, R) ->
    R ++ integer_to_list(Count) ++ CurrChar;
doEncode(S, CurrChar, Count, R) ->
    NextChar = string:substr(S, 1, 1),
    if
        NextChar == CurrChar ->
            doEncode(string:substr(S, 2), CurrChar, Count + 1, R);
        true ->
            doEncode(string:substr(S, 2), NextChar, 1,
                R ++ integer_to_list(Count) ++ CurrChar)
    end.

decode(S) ->
    doDecode(string:substr(S, 2), string:substr(S, 1, 1), []).

doDecode([], _, R) ->
    R;
doDecode(S, CurrString, R) ->
    NextChar = string:substr(S, 1, 1),
    IsInt = erlang:is_integer(catch(erlang:list_to_integer(NextChar))),
    if
        IsInt ->
            doDecode(string:substr(S, 2), CurrString ++ NextChar, R);
        true ->
            doDecode(string:substr(S, 2), [],
                R ++ string:copies(NextChar, list_to_integer(CurrString)))
    end.

rle_test_() ->
    PreEncoded =
        "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW",
    Expected = "12W1B12W3B24W1B14W",
    [
        ?_assert(encode(PreEncoded) =:= Expected),
        ?_assert(decode(Expected) =:= PreEncoded),
        ?_assert(decode(encode(PreEncoded)) =:= PreEncoded)
    ].
