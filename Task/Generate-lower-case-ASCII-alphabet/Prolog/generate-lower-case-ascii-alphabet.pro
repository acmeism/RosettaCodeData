a_to_z(From, To, L) :-
	maplist(atom_codes, [From, To], [[C_From], [C_To]]),
	bagof([C], between(C_From, C_To, C), L1),
	maplist(atom_codes,L, L1).
