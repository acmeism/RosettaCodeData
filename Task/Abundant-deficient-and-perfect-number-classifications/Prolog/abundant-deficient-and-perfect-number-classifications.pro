proper_divisors(1, []) :- !.
proper_divisors(N, [1|L]) :-
	FSQRTN is floor(sqrt(N)),
	proper_divisors(2, FSQRTN, N, L).

proper_divisors(M, FSQRTN, N, [MS|L]) :-
	between(M, FSQRTN, D1),
	N mod D1 =:= 0, !,
	D2 is N//D1, % must be integer
	( D1 < D2
	  ->
	    MS is D1 + D2, % already sum here
 	    M2 is D1 + 1,
	    proper_divisors(M2, FSQRTN, N, L)
	  ;
	    MS is D1, L = [] % D1 only once
	).
proper_divisors(_, _FSQRTN, _, []) :- !.

dpa(1, [1], [], []) :-
	!.
dpa(N, D, P, A) :-
	N > 1,
	proper_divisors(N, PN),
	sum_list(PN, SPN),
	compare(VGL, SPN, N),
	dpa(VGL, N, D, P, A).

dpa(<, N, [N|D], P, A) :- N1 is N-1, dpa(N1, D, P, A).
dpa(=, N, D, [N|P], A) :- N1 is N-1, dpa(N1, D, P, A).
dpa(>, N, D, P, [N|A]) :- N1 is N-1, dpa(N1, D, P, A).


dpa(N) :-
	T0 is cputime,
	dpa(N, D, P, A),
	Dur is cputime-T0,
	length(D, LD),
	length(P, LP),
	length(A, LA),
	format("deficient: ~d~n abundant: ~d~n  perfect: ~d~n",
		   [LD, LA, LP]),
	format("took ~f seconds~n", [Dur]).
