-module(ascii3d).
-export([decode/1]).

decode(Str) ->
    Splited = re:split(Str, "(\\d+)(\\D+)", [{return,list},group,trim]),
    Fun = fun([_,N,S]) -> {Num,_} = string:to_integer(N), lists:duplicate(Num, S) end,
    Joined = string:join(lists:flatmap(Fun, Splited), ""),
    Lines = binary:replace(binary:list_to_bin(Joined), <<"B">>, <<"\\">>, [global]),
    io:format("~s~n", [Lines]).
