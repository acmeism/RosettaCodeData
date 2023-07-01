horner([], _X, 0).

horner([H|T], X, V) :-
	horner(T, X, V1),
	V is V1 * X + H.
