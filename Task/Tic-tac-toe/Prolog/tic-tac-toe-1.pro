:- use_module('min-max.pl').

:-dynamic box/2.
:- dynamic tic_tac_toe_window/1.

% Computer begins.
tic-tac-toe(computer) :-
	V is random(9),
	TTT = [_,_,_,_,_,_ ,_,_,_],
	nth0(V, TTT, o),
	display_tic_tac_toe(TTT).

% Player begins
tic-tac-toe(me) :-
	TTT = [_,_,_,_,_,_ ,_,_,_],
	display_tic_tac_toe(TTT).


display_tic_tac_toe(TTT) :-
	retractall(box(_,_)),
	retractall(tic_tac_toe_window(_)),
	new(D, window('Tic-tac-Toe')),
	send(D, size, size(170,170)),
	X = 10, Y = 10,
	display(D, X, Y, 0, TTT),
	assert(tic_tac_toe_window(D)),
	send(D, open).

display(_, _, _, _, []).

display(D, X, Y, N, [A,B,C|R]) :-
	display_line(D, X, Y, N, [A,B,C]),
	Y1 is Y+50,
	N3 is N+3,
	display(D, X, Y1, N3, R).


display_line(_, _, _, _, []).
display_line(D, X, Y, N, [C|R]) :-
	(   nonvar(C)-> C1 = C; C1 = ' '),
	new(B, tic_tac_toe_box(C1)),
	assertz(box(N, B)),
	send(D, display, B, point(X, Y)),
	X1 is X + 50,
	N1 is N+1,
	display_line(D, X1, Y, N1, R).



% class tic_tac_toe_box
% display an 'x' when the player clicks
% display an 'o' when the computer plays
:- pce_begin_class(tic_tac_toe_box, box, "Graphical window with text").

variable(mess, any, both, "text to display").

initialise(P, Lbl) :->
	send(P, send_super, initialise),
	send(P, slot, mess, Lbl),
	WS = 50, HS = 50,
	send(P, size, size(WS,HS)),
	send(P, recogniser,
	     handler_group(new(click_gesture(left,
					     '',
					     single,
					     message(@receiver, my_click))))).

% the box is clicked
my_click(B) :->
	send(B, set_val, x),
	send(@prolog, play).

% only works when the box is "free"
set_val(B, Val) :->
	get(B, slot, mess, ' '),
	send(B, slot, mess, Val),
	send(B, redraw),
	send(B, flush).


%  redefined method to display custom graphical objects.
'_redraw_area'(P, A:area) :->
	send(P, send_super, '_redraw_area', A),
	%we display the text
	get(P, slot, mess, Lbl),
	new(Str1, string(Lbl)),
	get_object(P, area, area(X,Y,W,H)),
	send(P, draw_box, X, Y, W, H),
	send(P, draw_text, Str1,
		font(times, normal, 30),
		X, Y, W, H, center, center).

:- pce_end_class.

play :-
	numlist(0, 8, L),
	maplist(init, L, TTT),
	finished(x, TTT, Val),
	(   Val = 2 -> send(@display, inform,'You win !'),
	               tic_tac_toe_window(D),
		       send(D, destroy)
	;   (	Val = 1 -> send(@display, inform,'Draw !'),
	                   tic_tac_toe_window(D),
		           send(D, destroy)
	    ;	next_move(TTT, TT1),
		maplist(display, L, TT1),
		finished(o, TT1, V),
		(   V = 2 -> send(@display, inform,'I win !'),
			     tic_tac_toe_window(D),
		             send(D, destroy)
		;   (	V = 1 -> send(@display, inform,'Draw !'),
		                 tic_tac_toe_window(D),
			         send(D, destroy)
		    ;	true)))).


% use minmax to compute the next move
next_move(TTT, TT1) :-
	minimax(o, 0, 1024, TTT, _V1- TT1).


% we display the new board
display(I, V) :-
	nonvar(V),
	box(I, V1),
	send(V1, set_val, V).

display(_I, _V).

% we create the board for minmax
init(I, V) :-
	box(I, V1),
	get(V1, slot, mess, V),
	V \= ' '.

init(_I, _V).

% winning position for the player P ?
winned(P, [A1, A2, A3, A4, A5, A6, A7, A8, A9]) :-
       (is_winning_line(P, [A1, A2, A3]);
	is_winning_line(P, [A4, A5, A6]);
	is_winning_line(P, [A7, A8, A9]);
	is_winning_line(P, [A1, A4, A7]);
	is_winning_line(P, [A2 ,A5, A8]);
	is_winning_line(P, [A3, A6, A9]);
	is_winning_line(P, [A1, A5, A9]);
	is_winning_line(P, [A3, A5, A7])).


is_winning_line(P, [A, B, C]) :-
	nonvar(A), A = P,
	nonvar(B), B = P,
	nonvar(C), C = P.

% Winning position for the player
eval(Player, Deep, TTT, V) :-
	winned(Player, TTT),
	(   Player = o -> V is 1000 - 50 * Deep; V is -1000+ 50 * Deep).

% Loosing position for the player
eval(Player, Deep, TTT, V) :-
	select(Player, [o,x], [Player1]),
	winned(Player1, TTT),
	(   Player = x -> V is 1000 - 50 * Deep; V is -1000+ 50 * Deep).

% Draw position
eval(_Player, _Deep, TTT, 0) :-
	include(var, TTT, []).


% we fetch the free positions of the board
possible_move(TTT, LMove) :-
	new(C, chain),
	forall(between(0,8, I),
	       (   nth0(I, TTT, X),
		   (   var(X) -> send(C, append, I); true))),
	chain_list(C, LMove).

% we create the new position when the player P clicks
% the box "N"
assign_move(P, TTT, N, TT1) :-
	copy_term(TTT, TT1),
	nth0(N, TT1, P).

% We fetch all the possible boards obtained from board TTT
% for the player P
get_next(Player, Deep, TTT, Player1, Deep1, L):-
	possible_move(TTT, LMove),
	select(Player, [o,x], [Player1]),
	Deep1 is Deep + 1,
	maplist(assign_move(Player, TTT), LMove, L).


% The game is over ?
% Player P wins
finished(P, TTT, 2) :-
	winned(P, TTT).

% Draw
finished(_P, TTT, 1) :-
	include(var, TTT, []).

% the game is not over
finished(_P, _TTT, 0) .

% minmax must knows when the computer plays
% (o for ordinateur in French)
computer(o).
