incr_numerical_string(S1, S2) :-
	string_to_atom(S1, A1),
	atom_number(A1, N1),
	N2 is N1+1,
	atom_number(A2, N2),
	string_to_atom(S2, A2).
