:- module('min-max.pl', [minimax/5]).

% minimax(Player, Deep, MaxDeep, B, V-B)
% @arg1 : current player at this level
% @arg2 : current level of recursion
% @arg3 : max level of recursion (in this version of the game no use : set to 1024 !)
% @arg4 : current board
% @arg5 : B is the evaluation of the board, the result is V-B to know the new board

% Here we get an evaluation
minimax(Player, Deep, MaxDeep, B, V-B) :-
	(   eval(Player, Deep, B, V) -> true
	; % in this version of the game this second division always fails
	(   Deep > MaxDeep -> V is random(1000) - 1000)).

% here we must compute all the possible moves to know the evaluation of the board
minimax(Player, Deep, MaxDeep, B, V) :-
	get_next(Player, Deep, B, Player1, Deep1, L),
	maplist(minimax(Player1, Deep1, MaxDeep), L, LV),
	maplist(lie, L, LV, TLV),
	sort(TLV, SLVTmp),
	(   computer(Player) -> reverse(SLVTmp, SLV); SLV = SLVTmp),
	SLV = [V | _R].


lie(TTT, V-_, V-TTT).
