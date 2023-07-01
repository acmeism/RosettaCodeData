-module(bitwise_operations).

-export([test/0]).

test() ->
   A = 255,
   B = 170,
   io:format("~p band ~p = ~p\n",[A,B,A band B]),
   io:format("~p bor ~p = ~p\n",[A,B,A bor B]),
   io:format("~p bxor ~p = ~p\n",[A,B,A bxor B]),
   io:format("not ~p = ~p\n",[A,bnot A]),
   io:format("~p bsl ~p = ~p\n",[A,B,A bsl B]),
   io:format("~p bsr ~p = ~p\n",[A,B,A bsr B]).
