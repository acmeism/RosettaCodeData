largest_int_v2(In, Out) :-
	maplist(name, In, LC),
	predsort(my_sort,LC, LCS),
	append(LCS, LC1),
	name(Out, LC1).


my_sort(R, L1, L2) :-
	append(L1, L2, V1), name(I1, V1),
	append(L2, L1, V2), name(I2, V2),
	(   I1 < I2, R = >; I1 = I2, R = '='; R = <).



% particular case  95 958
my_sort(>, [H1], [H1,  H2 | _]) :-
	H1 > H2.

my_sort(<, [H1], [H1, H2 | _]) :-
	H1 < H2.

my_sort(R, [H1], [H1, H1 | T]) :-
	my_sort(R, [H1], [H1 | T]).



% particular case  958 95
my_sort(>, [H1,  H2 | _], [H1]) :-
	H1 > H2.

my_sort(<, [H1,  H2 | _], [H1]) :-
	H1 < H2.

my_sort(R, [H1,  H1 | T], [H1]) :-
	my_sort(R, [H1 | T], [H1]) .
