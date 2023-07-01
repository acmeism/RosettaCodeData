max_list(L, V) :-
	select(V, L, R), \+((member(X, R), X > V)).
