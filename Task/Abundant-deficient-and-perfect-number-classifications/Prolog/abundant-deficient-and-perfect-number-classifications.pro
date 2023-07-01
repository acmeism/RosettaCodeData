proper_divisors(1, []) :- !.
proper_divisors(N, [1|L]) :-
	FSQRTN is floor(sqrt(N)),
	proper_divisors(2, FSQRTN, N, L).

proper_divisors(M, FSQRTN, _, []) :-
	M > FSQRTN,
	!.
proper_divisors(M, FSQRTN, N, L) :-
	N mod M =:= 0, !,
	MO is N//M, % must be integer
	L = [M,MO|L1], % both proper divisors
	M1 is M+1,
	proper_divisors(M1, FSQRTN, N, L1).
proper_divisors(M, FSQRTN, N, L) :-
	M1 is M+1,
	proper_divisors(M1, FSQRTN, N, L).

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
