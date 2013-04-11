-module(test).
-export([first/1, second/0]).

first(F) -> F().
second() -> hello.
