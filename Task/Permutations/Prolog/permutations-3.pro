% permut_Prolog(P, L)
% P is a permutation of L

permut_Prolog([], []).
permut_Prolog([H | T], NL) :-
	select(H, NL, NL1),
	permut_Prolog(T, NL1).
