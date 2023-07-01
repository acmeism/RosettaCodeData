:- use_module(library(lambda)).

catamorphism :-
	numlist(1,10,L),
	foldl(\XS^YS^ZS^(ZS is XS+YS), L, 0, Sum),
	format('Sum of ~w is ~w~n', [L, Sum]),
	foldl(\XP^YP^ZP^(ZP is XP*YP), L, 1, Prod),
	format('Prod of ~w is ~w~n', [L, Prod]),
	string_to_list(LV, ""),
	foldl(\XC^YC^ZC^(string_to_atom(XS, XC),string_concat(YC,XS,ZC)),
	      L, LV, Concat),
	format('Concat of ~w is ~w~n', [L, Concat]).
