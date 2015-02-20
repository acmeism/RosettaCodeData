:- use_module(library(clpfd)).
comb_lstcomp(N, M, V) :-
	V <- {L	& length(L, N), L ins 1..M & all_distinct(L), chain(L, #<), label(L)}.
