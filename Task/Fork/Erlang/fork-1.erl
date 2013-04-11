-module(fork).
-export([start/0]).

start() ->
    spawn(fork,child,[]),
    io:format("This is the original process~n").

child() ->
    io:format("This is the new process~n").
