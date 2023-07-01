-module(sort).
-export([insertion/1]).

insertion(L) -> lists:foldl(fun insert/2, [], L).

insert(X,[]) -> [X];
insert(X,L=[H|_]) when X =< H -> [X|L];
insert(X,[H|T]) -> [H|insert(X, T)].
