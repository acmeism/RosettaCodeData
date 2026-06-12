#!/usr/bin/env escript

-module(hello).
-export([main/1]).

main(_) -> io:format("Hello World!~n", []).
