doors_unoptimized(N) :-
	length(L, N),
	maplist(init, L),
	doors(N, N, L, L1),
	affiche(N, L1).

init(close).

doors(Max, 1, L, L1) :-
	!,
       inverse(1, 1, Max, L, L1).

doors(Max, N, L, L1) :-
	N1 is N - 1,
	doors(Max, N1, L, L2),
	inverse(N, 1, Max, L2, L1).


inverse(N, Max, Max, [V], [V1]) :-
	!,
	0 =:= Max mod N -> inverse(V, V1); V1 = V.

inverse(N, M, Max, [V|T], [V1|T1]) :-
	M1 is M+1,
	inverse(N, M1, Max, T, T1),
	(   0 =:= M mod N -> inverse(V, V1); V1 = V).


inverse(open, close).
inverse(close, open).

affiche(N, L) :-
	forall(between(1, N, I),
	       (   nth1(I, L, open) -> format('Door ~w is open.~n', [I]); true)).
