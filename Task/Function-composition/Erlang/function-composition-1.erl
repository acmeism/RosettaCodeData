-module(fn).
-export([compose/2, multicompose/1]).

compose(F,G) -> fun(X) -> F(G(X)) end.

multicompose(Fs) ->
    lists:foldl(fun compose/2, fun(X) -> X end, Fs).
