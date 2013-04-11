fact(N, NF) :-
	fact(1, N, 1, NF).

fact(X, X, F, F) :- !.
fact(X, N, FX, F) :-
	FX1 is FX * X,
	X1 is X + 1,
	fact(X1, N, FX1, F).
