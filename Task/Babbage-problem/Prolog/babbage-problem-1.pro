:- use_module(library(clpfd)).

babbage_(B, B, Sq) :-
	B * B #= Sq,
	number_chars(Sq, R),
	append(_, ['2','6','9','6','9','6'], R).
babbage_(B, R, Sq) :-
	N #= B + 1,
	babbage_(N, R, Sq).
	
babbage :-
	once(babbage_(1, Num, Square)),
	format('lowest number is ~p which squared becomes ~p~n', [Num, Square]).
