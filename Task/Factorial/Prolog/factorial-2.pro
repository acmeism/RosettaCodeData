fact(N, NF) :-
	fact(1, N, 1, NF).

fact(X, X, F, F) :- !.
fact(X, N, FX, F) :-
	X1 is X + 1,
	FX1 is FX * X1,
	fact(X1, N, FX1, F).
