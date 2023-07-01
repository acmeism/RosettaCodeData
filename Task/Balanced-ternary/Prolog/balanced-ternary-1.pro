:- module('bt_convert.pl', [bt_convert/2,
			    op(950, xfx, btconv),
			    btconv/2]).

:- use_module(library(clpfd)).

:- op(950, xfx, btconv).

X btconv Y :-
	bt_convert(X, Y).

% bt_convert(?X, ?L)
bt_convert(X, L) :-
	(   (nonvar(L), \+is_list(L)) ->string_to_list(L, L1);  L1 = L),
	convert(X, L1),
	(   var(L) -> string_to_list(L, L1); true).

% map numbers toward digits +, - 0
plus_moins( 1, 43).
plus_moins(-1, 45).
plus_moins( 0, 48).


convert(X, [48| L]) :-
	var(X),
	(   L \= [] -> convert(X, L); X = 0, !).

convert(0, L) :-
	var(L), !, string_to_list(L, [48]).

convert(X, L) :-
	(   (nonvar(X), X > 0)
	;   (var(X), X #> 0,
	    L = [43|_],
	     maplist(plus_moins, L1, L))),
	!,
	convert(X, 0, [], L1),
	(   nonvar(X) -> maplist(plus_moins, L1, LL),  string_to_list(L, LL)
	;   true).

convert(X, L) :-
	(  nonvar(X) -> Y is -X
	;  X #< 0,
	   maplist(plus_moins, L2, L),
	   maplist(mult(-1), L2, L1)),
	convert(Y, 0, [], L1),
	(   nonvar(X) ->
	    maplist(mult(-1), L1, L2),
	    maplist(plus_moins, L2, LL),
            string_to_list(L, LL)
	;   X #= -Y).

mult(X, Y, Z) :-
	Z #= X * Y.


convert(0, 0, L, L) :-  !.

convert(0, 1, L, [1 | L]) :- !.


convert(N, C, LC, LF) :-
	R #= N mod 3 + C,
	R #> 1 #<==> C1,
	N1 #= N / 3,
	R1 #= R - 3 * C1, % C1 #= 1,
	convert(N1, C1, [R1 | LC], LF).
