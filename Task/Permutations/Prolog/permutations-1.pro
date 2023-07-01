:- use_module(library(clpfd)).

permut_clpfd(L, N) :-
    length(L, N),
    L ins 1..N,
    all_different(L),
    label(L).
