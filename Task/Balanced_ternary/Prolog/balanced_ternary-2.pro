:- module('bt_add.pl', [bt_add/3,
			bt_add1/3,
			op(900, xfx, btplus),
			op(900, xfx, btmoins),
			btplus/2,
			btmoins/2,
			strip_nombre/3
		       ]).

:- op(900, xfx, btplus).
:- op(900, xfx, btmoins).

% define operator btplus
A is X btplus Y :-
	bt_add(X, Y, A).

% define operator btmoins
% no need to define a predicate for the substraction
A is X btmoins Y :-
       X is Y btplus A.


% bt_add(?X, ?Y, ?R)
% R is X + Y
% X, Y, R are strings
% At least 2 args must be instantiated
bt_add(X, Y, R) :-
	(   nonvar(X) -> string_to_list(X, X1);  true),
	(   nonvar(Y) -> string_to_list(Y, Y1);  true),
	(   nonvar(R) -> string_to_list(R, R1);  true),
	bt_add1(X1, Y1, R1),
	(   var(X) -> string_to_list(X, X1); true),
	(   var(Y) -> string_to_list(Y, Y1); true),
	(   var(R) -> string_to_list(R, R1); true).



% bt_add1(?X, ?Y, ?R)
% R is X + Y
% X, Y, R are lists
bt_add1(X, Y, R) :-
	% initialisation :  X and Y must have the same length
	% we add zeros at the beginning of the shortest list
	(   nonvar(X) -> length(X, LX);  length(R, LR)),
	(   nonvar(Y) ->  length(Y, LY);  length(R, LR)),
	(   var(X) -> LX is max(LY, LR) , length(X1, LX), Y1 = Y ; X1 = X),
	(   var(Y) -> LY is max(LX, LR) , length(Y1, LY), X1 = X ; Y1 = Y),

	Delta is abs(LX - LY),
	(   LX < LY -> normalise(Delta, X1, X2), Y1 = Y2
	;   LY < LX -> normalise(Delta, Y1, Y2), X1 = X2
	;   X1 = X2, Y1 = Y2),


	% if R is instancied, it must have, at least, the same length than X or Y
	Max is max(LX, LY),
	(   (nonvar(R), length(R, LR), LR < Max) -> Delta1 is Max - LR, normalise(Delta1, R, R2)
	;   nonvar(R) -> R = R2
	;   true),

	 bt_add(X2, Y2, C, R2),

	(   C = 48 -> strip_nombre(R2, R, []),
	              (	  var(X) -> strip_nombre(X2, X, []) ; true),
	              (	  var(Y) -> strip_nombre(Y2, Y, []) ; true)
	;   var(R) -> strip_nombre([C|R2], R, [])
	;   ( select(C, [45,43], [Ca]),
	    ( var(X) -> strip_nombre([Ca | X2], X, [])
	    ;	strip_nombre([Ca | Y2], Y, [])))).


% here we actually compute the sum
bt_add([], [], 48, []).

bt_add([H1|T1], [H2|T2], C3, [R2 | L]) :-
	bt_add(T1, T2, C, L),
	% add HH1 and H2
	ternary_sum(H1, H2, R1, C1),
	% add first carry,
	ternary_sum(R1, C, R2, C2),
	% add second carry
	ternary_sum(C1, C2, C3, _).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ternary_sum
% @arg1 : V1
% @arg2 : V2
% @arg3 : R is V1 + V2
% @arg4 : Carry
ternary_sum(43, 43, 45, 43).

ternary_sum(43, 45, 48, 48).

ternary_sum(45, 43, 48, 48).

ternary_sum(45, 45, 43, 45).

ternary_sum(X, 48, X, 48).

ternary_sum(48, X, X, 48).


% if L has a length smaller than N, complete L with 0 (code 48)
normalise(0, L, L) :- !.
normalise(N, L1, L) :-
	N1 is N - 1,
	normalise(N1, [48 | L1], L).


% contrary of normalise
% remove leading zeros.
% special case of number 0 !
strip_nombre([48]) --> {!}, "0".

% enlÃ¨ve les zÃ©ros inutiles
strip_nombre([48 | L]) -->
	strip_nombre(L).


strip_nombre(L) -->
	L.
