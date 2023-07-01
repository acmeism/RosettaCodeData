/* -------------------------------------------------------------
   Entry point, just create a blank grid and enter a 'game loop'
   -------------------------------------------------------------*/
play_2048 :-
	welcome_msg,
	length(Grid, 16), maplist(=(' '), Grid), % create a blank grid
	play(Grid, yes), !. % don't have to cut here but it makes the exit cleaner


/* -----------------------------------------------
   Messages that will be printed at various points
   -----------------------------------------------*/
welcome_msg :- 	
	format('~nWelcome to the Prolog version of 2048~n~n'),
	format('To play using w,s,a,d keys for movement, q to quit~n~n').	
contrats_msg :- format('Congratulations, you reached 2048!~n~n').
loser_msg :- format('Uh Oh, you could not quite make it to 2048...~n~n').
quit_msg :- format('Bye then!~n~n').
	
	
/* -------------------
   End game conditions
   -------------------*/
player_not_won_yet(Grid) :- maplist(dif(2048), Grid).
player_wins(Grid) :- member(2048, Grid).
player_loses(G) :- move(up, G, G), move(down, G, G), move(left, G, G), move(right, G, G).

	
/* ---------
   Game loop
   ---------*/	
% First check if the player has reached the win condition, if not find how many spaces are left
play(Grid, _) :- 	
	player_wins(Grid),
	draw_grid(Grid),
	contrats_msg.
play(Grid, CreateNewNum) :-
	player_not_won_yet(Grid),
	include(=(' '), Grid, Spaces), length(Spaces, NSpaces), % the number of spaces in the grid
	play(Grid, CreateNewNum, NSpaces).

% knowing the number of spaces, determine if there is a space, and if we need a new number, and generate.	
play(Grid, no, _) :- play(Grid).
play(Grid, yes, 0) :- play(Grid).
play(Grid, yes, NSpaces) :-
	dif(NSpaces, 0),
	random_space(NSpaces, Grid, GridWithRandom),
	play(GridWithRandom).

% with the new number on the grid we can tell if the player has lost the game yet
% if not, draw the grid and get the next action by the player
play(Grid) :-
	player_loses(Grid),
	draw_grid(Grid),
	loser_msg.		
play(Grid) :-
	\+ player_loses(Grid),
	draw_grid(Grid),
	next_move_by_player(Move),
	player_made_move(Grid, Move).

% determine the result of player move	
player_made_move(_, quit).
player_made_move(Grid, Move) :-
	dif(Move, quit),
	move(Move, Grid, Grid), % The move creating the same grid indicates that no merge was done
	play(Grid, no). % don't create a new number
player_made_move(Grid, Move) :-
	dif(Move, quit),
	move(Move, Grid, MovedGrid),
	dif(Grid, MovedGrid),
	play(MovedGrid, yes).

	
/* ---------------------------------------
   Get the next move from the player input
   ---------------------------------------*/	
next_move_by_player(Move) :-
	repeat,
	get_single_char(Char),
	key_move(Char, Move).

% valid keys are: up = 'w', down = 's', left = 'a' right = 'd', quit = 'q'
key_move(119, up). key_move(115, down).	key_move(97, left). key_move(100, right). key_move(113, quit).


/* ------------------
   Draw the Game grid
   ------------------*/
draw_grid([A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4]) :-
	format(   '+-------------------+~n'),
	row([A1,A2,A3,A4]),
	row([B1,B2,B3,B4]),
	row([C1,C2,C3,C4]),
	maplist(draw, [D1,D2,D3,D4]),
	format('¦~n+-------------------+~n~n~n').

row([A,B,C,D]) :- maplist(draw, [A,B,C,D]), format('¦~n¦----+----+----+----¦~n').	
	
draw(' ') :- format('¦    ').
draw(X) :- member(X,[2,4,8]), format('¦  ~d ', X).
draw(X) :- member(X,[16,32,64]), format('¦ ~d ', X).
draw(X) :- member(X,[128,256,512]), format('¦ ~d', X).
draw(X) :- member(X,[1024,2048]), format('¦~d', X).

	
/* ----------------------------------------
   Populate a random space with a new value
   ----------------------------------------*/
random_space(0, G, G).
random_space(1, Grid, GridWithRandom) :-
	four_or_two(V),
	select(' ', Grid, V, GridWithRandom).
random_space(N, Grid, GridWithRandom) :-
	N > 1,
	four_or_two(V),
	random(1, N, P),	
	replace_space(P, V, Grid, GridWithRandom).
	
replace_space(0, V, [' '|T], [V|T]).
replace_space(P, V, [' '|T], [' '|R]) :-	succ(NextP, P),	replace_space(NextP, V, T, R).
replace_space(P, V, [H|T], [H|R]) :-	dif(' ', H), replace_space(P, V, T, R).
	
four_or_two(V) :- random(1, 10, IsFour), IsFour = 1 -> V = 4 ; V = 2.
	

/* ------------------------------------------
   Process a game move based on the direction
   ------------------------------------------*/
move(Direction, UnMoved, Moved) :-
	map_move(Direction, UnMoved, UnMovedMapped),
	maplist(combine_row, UnMovedMapped, MovedMapped),
	map_move(Direction, Moved, MovedMapped).
	
% convert the array to a set of lists that can be moved in the same
% direction. This can be reversed after the move is completed.
map_move(up, [A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4], [[D1,C1,B1,A1],[D2,C2,B2,A2],[D3,C3,B3,A3],[D4,C4,B4,A4]]).
map_move(down, [A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4], [[A1,B1,C1,D1],[A2,B2,C2,D2],[A3,B3,C3,D3],[A4,B4,C4,D4]]).
map_move(left, [A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4], [[A4,A3,A2,A1],[B4,B3,B2,B1],[C4,C3,C2,C1],[D4,D3,D2,D1]]).
map_move(right, [A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4], [[A1,A2,A3,A4],[B1,B2,B3,B4],[C1,C2,C3,C4],[D1,D2,D3,D4]]).

% remove all the spaces, then put them at the front of the list
combine_row(UnMoved, Moved) :-
	partition(=(' '), UnMoved, Blank, Set),
	append(Blank, Set, ReadyToMove),
	combine(ReadyToMove, Moved).

% combine based on the rules of the game.
combine([A,B,C,D], [A,B,C,D]) :- dif(A,B), dif(B,C), dif(C,D).	
combine([A,A,B,B], [' ',' ',Ad,Bd]) :- dbl(A,Ad), dbl(B,Bd).
combine([A,B,C,C], [' ',A,B,Cd]) :- dif(A,B), dbl(C,Cd).
combine([A,B,B,C], [' ',A,Bd,C]) :-	dif(B,C), dbl(B,Bd).
combine([A,A,B,C], [' ',Ad,B,C]) :- dif(A,B), dif(B,C), dbl(A, Ad).
combine([A,B,C,C], [' ',A,B,Cd]) :- dif(A,B), dif(B,C), dbl(C,Cd).

% this could be done using maths, but it is more prology this way.
dbl(' ', ' ').
dbl(2,4). dbl(4,8). dbl(8,16). dbl(16,32). dbl(32,64). dbl(64,128). dbl(128,256). dbl(256,512). dbl(512,1028). dbl(1028,2048).
