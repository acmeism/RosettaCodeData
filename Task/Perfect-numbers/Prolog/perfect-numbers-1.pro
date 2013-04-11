tt_divisors(X, N, TT) :-
	Q is X / N,
	(   0 is X mod N -> (Q = N -> TT1 is N + TT;
                             TT1 is N + Q + TT);
            TT = TT1),
	(   sqrt(X) > N + 1 -> N1 is N+1, tt_divisors(X, N1, TT1);
	    TT1 = X).

perfect(X) :-
	tt_divisors(X, 2, 1).

perfect_numbers(N, L) :-
	numlist(2, N, LN),
	include(perfect, LN, L).
