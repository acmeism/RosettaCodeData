largest_int_v1(In, Out) :-
	maplist(name, In, LC),
	aggregate(max(V), get_int(LC, V), Out).


get_int(LC, V) :-
	permutation(LC, P),
	append(P, LV),
	name(V, LV).
