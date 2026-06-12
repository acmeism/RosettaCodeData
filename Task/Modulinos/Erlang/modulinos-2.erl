-module(scriptedmain).
-export([meaning_of_life/0, start/0]).

meaning_of_life() -> 42.

start() ->
  io:format("Main: The meaning of life is ~w~n", [meaning_of_life()]),
  init:stop().
