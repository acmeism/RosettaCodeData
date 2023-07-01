:- use_module(library(lambda)).

congruence(Congruence,  In, Fun, Out) :-
	maplist(Congruence +\X^Y^(Y is X mod Congruence), In, In1),
	call(Fun, In1, Out1),
	maplist(Congruence +\X^Y^(Y is X mod Congruence), Out1, Out).

fun_1([X], [Y]) :-
	Y is X^100 + X + 1.

fun_2(L, [R]) :-
	sum_list(L, R).
