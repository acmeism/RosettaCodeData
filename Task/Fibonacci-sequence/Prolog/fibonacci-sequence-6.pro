:- use_module(lambda).
fib(N, FN) :-
	cont_fib(N, _, FN, \_^Y^_^U^(U = Y)).

cont_fib(N, FN1, FN, Pred) :-
	(   N < 2 ->
	    call(Pred, 0, 1, FN1, FN)
	;
	    N1 is N - 1,
	    P = \X^Y^Y^U^(U is X + Y),
	    cont_fib(N1, FNA, FNB, P),
	    call(Pred, FNA, FNB, FN1, FN)
	).
