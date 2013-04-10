:- use_module(library(clpfd)).

comb_clpfd(L, M, N) :-
    length(L, M),
    L ins 1..N,
    chain(L, #<),
    label(L).
