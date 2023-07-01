sum_of_multiples_of_3_and_5_slow(N, TT) :-
	sum_of_multiples_of_3_and_5(N, 1, 0, TT).

sum_of_multiples_of_3_and_5(N, K, S, S) :-
	3 * K >= N.

sum_of_multiples_of_3_and_5(N, K, C, S) :-
	T3 is 3 * K, T3 < N,
	C3 is C + T3,
	T5 is 5 * K,
	(   (T5 < N, K mod 3 =\= 0)
	->  C5 is C3 + T5
	;   C5 = C3),
	K1 is K+1,
	sum_of_multiples_of_3_and_5(N, K1, C5, S).
