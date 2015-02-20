:-use_module(library(lambda)).


closure :-
	numlist(1,10, Lnum),
	maplist(make_func, Lnum, Lfunc),
	maplist(call_func, Lnum, Lfunc).


make_func(I, \X^(X is I*I)).

call_func(N, F) :-
	call(F, R),
	format('Func ~w : ~w~n', [N, R]).
