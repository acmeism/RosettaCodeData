doors_optimized(N) :-
	Max is floor(sqrt(N)),
	forall(between(1, Max, I),
	       (   J is I*I,format('Door ~w is open.~n',[J]))).
