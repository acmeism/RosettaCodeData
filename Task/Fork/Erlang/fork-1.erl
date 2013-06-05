-module(fork).
-export([start/0]).

start() ->
    erlang:spawn( fun() -> child() end ),
    io:format("This is the original process~n").

child() ->
    io:format("This is the new process~n").
