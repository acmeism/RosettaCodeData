-module(fn).
-export([compose/1, multicompose/2]).

compose(F,G) -> fun(X) -> F(G(X)) end.

multicompose(Fs) ->
    lists:foldl(fun compose/2, fun(X) -> X end, Fs).
