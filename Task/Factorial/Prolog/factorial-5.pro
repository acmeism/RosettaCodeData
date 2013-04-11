:- use_module(lambda).

fact(N, FN) :-
	cont_fact(N, FN, \X^Y^(Y = X)).

cont_fact(N, F, Pred) :-
	(   N = 0 ->
	    call(Pred, 1, F)
	;   N1 is N - 1,

	    P =  \Z^T^(T is Z * N),
	    cont_fact(N1, FT, P),
	    call(Pred, FT, F)
	).
