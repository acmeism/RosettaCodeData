sum_of_multiples_of_3_and_5_fast(N, TT):-
	maplist(compute_sum(N), [3,5,15], [TT3, TT5, TT15]),
	TT is TT3 + TT5 - TT15.

compute_sum(N, N1, Sum) :-
	(   N mod N1 =:= 0
	->  N2 is N div N1 - 1
	;   N2 is N div N1),
	Sum is N1 * N2 * (N2 + 1) / 2.
