bogo_sort(L,Rl) :-
	min_list(L,Min),
	repeat,
	random_permutation(L,Rl),
	is_sorted(Rl,Min),
	!.
	
is_sorted([],_).
is_sorted([N|T],P) :-
	N >= P,
	is_sorted(T,N).
