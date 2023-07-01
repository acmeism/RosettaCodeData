:- use_module(library(clpfd)).

% Play - run the minesweeper game with a specified width and height
play(W,H) :-
	format('
Welcome to prolog minesweeper!
: o X Y  exposes a cell of the grid
: m X Y  marks bombs

Any else to quit.
'),

	make_grid(W, H, Grid),
	!,
	play(Grid),
	!.

play(Grid) :- % win condition is true
	map_grid(won, Grid),
	map_grid(print_cell, Grid),
	writeln('you won!').

play(Grid) :- % lose condition is true
	\+ map_grid(still_playing, Grid),
	map_grid(print_cell, Grid),
	writeln('you hit a bomb!').

play(Grid) :- % stil playing
	map_grid(print_cell, Grid),
	parse_input(Op, X, Y),
	do_op(Op, p(X,Y), Grid, Grid2),
	!,
	play(Grid2).

/* Create a new Grid
 *
 * The grid is created initially as a flat list, and after everything
 * has been populated is converted into a 2 dimensional array.
 */
make_grid(W, H, grid(W,H,MappedCells)) :-
	% create a flat list
	Len is W * H,
	length(Cells, Len),

	% create a list of bombs that is 20% of the grid list
	NBombs is W * H / 5,
	floor(NBombs, NBint),
	format('There are ~w bombs on the grid~n', NBint),
	length(AllBombs, NBint),
	maplist(=('?'), AllBombs),
	% add the bombs to the start of the grid list
	map_bombs_to_cells(Cells, AllBombs, NewC),

	% randomise and convert to a 2D array
	random_permutation(NewC, RCells),
	convert_col(RCells, W, H, CreatedCells),

	% populate the hidden part of the grid with number of bombs next to each cell
	map_grid(adj_bomb(grid(W,H,CreatedCells)), grid(W,H,CreatedCells), grid(W,H,MappedCells)).

% puts the bombs at the start of the flat list before shuffling.
map_bombs_to_cells(C, [], C).
map_bombs_to_cells([_|Ct], [B|Bt], [B|R]) :- map_bombs_to_cells(Ct, Bt, R).

convert_row(T, 0, [], T).
convert_row([H|T], W, [H|R], Rem) :-
	dif(W, 0), succ(W1, W),
	convert_row(T, W1, R, Rem).

convert_col([], _, 0, []).
convert_col(C, W, H, [Row|MoreCells]) :- dif(H, 0), succ(H1, H),
	convert_row(C, W, Row, Rem),
	convert_col(Rem, W, H1, MoreCells).

% determine the number of bombs next to a cell (use mapgrid)
adj_bomb(_, _, _, C, cell('.',C)) :- C =@= '?'.
adj_bomb(Grid, p(X,Y), D, Cell, cell('.',NBombs)) :-
	dif(Cell, '?'),
	findall(p(Ax,Ay), (
		adj(p(X,Y), D, p(Ax,Ay)),
		indomain(Ax), indomain(Ay),
		grid_val_xy(Grid, p(Ax,Ay), Val),
		Val =@= '?'
	), Bombs),
	length(Bombs, NBombs).

% Print the grid (use mapgrid)
print_cell(p(X,_), dim(X,_), cell(C,A), cell(C,A)) :- format("~w~n", C).
print_cell(p(X,_), dim(W,_), cell(C,A), cell(C,A)) :- dif(X,W), format("~w ", C).

% determine if we have lost yet or not (use mapgrid).
still_playing(_,_,cell(A,_),_) :- A \= '*'.

% determine if we have won yet or not (use mapgrid).
won(_,_,cell(N,N),_) :- integer(N).
won(_,_,cell('?','?'),_).

% Operate on all cells in a grid, this is a meta predicate that is
% applied several times throughout the code
map_grid(Goal, G) :- map_grid(Goal, G, G).

map_grid(Goal, grid(W,H,Cells), grid(W,H,OutCells)) :-
	map_grid_col(Cells, 1, dim(W,H), Goal, OutCells).

map_grid_col([], _, _, _, []).
map_grid_col([H|T], Y, D, Goal, [NRow|NCol]) :-
	map_grid_row(H, p(1, Y), D, Goal, NRow),
	succ(Y, Y1),
	map_grid_col(T, Y1, D, Goal, NCol).

map_grid_row([], _, _, _, []).
map_grid_row([H|T], p(X, Y), D, Goal, [Cell|R]) :-
	call(Goal, p(X, Y), D, H, Cell),
	succ(X, X1),
	map_grid_row(T, p(X1, Y), D, Goal, R).

% Get a value from the grid by X Y
grid_val_xy(grid(_,_,Cells), p(X,Y), Val) :-
	nth1(Y, Cells, Row),
	nth1(X, Row, Val).

% Set a value on the grid by X Y
grid_set_xy(grid(W,H,Cells), p(X,Y), Val, grid(W,H,NewCells)) :- grid_set_col(Cells, X, Y, Val, NewCells).
grid_set_col([H|T], X, 1, Val, [Row|T]) :- grid_set_row(H, X, Val, Row).
grid_set_col([H|T], X, Y, Val, [H|New]) :- dif(Y, 0), succ(Y1, Y), grid_set_col(T, X, Y1, Val, New).
grid_set_row([_|T], 1, Val, [Val|T]).
grid_set_row([H|T], X, Val, [H|New]) :- dif(X, 0), succ(X1, X), grid_set_row(T, X1, Val, New).

% All coordinates adjacent to an x,y position
adj(p(X,Y), dim(W,H), p(Ax,Ay)) :-

	dif(p(X,Y),p(Ax,Ay)),

	% adjacent X
	Ax in 1..W,
	Xmin #= X-1, Xmax #= X+1,
	Ax in Xmin..Xmax,

	% adjacent Y
	Ay in 1..H,
	Ymin #= Y-1, Ymax #= Y+1,
	Ay in Ymin..Ymax.

% get user operation from input
parse_input(Op, X, Y) :-
	read_line_to_codes(user_input, In),
	maplist(char_code, InChars, In),
	phrase(mine_op(Op, X, Y), InChars, []).

mine_op(mark, X, Y) --> [m], [' '], coords(X, Y).
mine_op(open, X, Y) --> [o], [' '], coords(X, Y).
coords(Xi, Yi) --> number_(X), { number_chars(Xi, X) }, [' '], number_(Y), { number_chars(Yi, Y) }.

number_([D|T]) --> digit(D), number_(T).
number_([D]) --> digit(D).
digit(D) --> [D], { char_type(D, digit) }.


% Do mark operation
do_op(mark, P, G, Ng) :-
	grid_val_xy(G, P, cell(_,A)),
	grid_set_xy(G, P, cell('?',A), Ng).

% Do open operation, opening a bomb
do_op(open, P, G, Ng) :-
	grid_val_xy(G, P, cell(_,'?')),
	grid_set_xy(G, P, cell('*','?'), Ng).

% Do open operation, not a bomb
do_op(open, P, G, Ng) :-
	grid_val_xy(G, P, cell(_,A)),
	dif(A, '?'),
	grid_set_xy(G, P, cell(A,A), Ng1),
	expose_grid(P, Ng1, Ng).

% expose the grid by checking all the adjacent cells and operating
% appropriately
expose_grid(p(X,Y), grid(W,H,Cells), Ng2) :-
	findall(p(Ax,Ay), (
		    adj(p(X,Y), dim(W,H), p(Ax,Ay)),
		    indomain(Ax), indomain(Ay)
		), Coords),
	expose_grid_(Coords, grid(W,H,Cells), Ng2).

expose_grid_([], G, G).

expose_grid_([H|T], G, Ng) :-  % this cell has already been exposed, continue
	grid_val_xy(G, H, cell(A,B)),
	member(A, [B,'?']),
	expose_grid_(T, G, Ng).

expose_grid_([H|T], G, Ng) :- % ignore bombs
	grid_val_xy(G, H, cell(_,'?')),
	expose_grid_(T, G, Ng).

expose_grid_([H|T], G, Ng) :- % is an integer, expose and continue
	grid_val_xy(G, H, cell(_,N)),
	integer(N),
	N #> 0,
	grid_set_xy(G, H, cell(N,N), Ng1),
	expose_grid_(T, Ng1, Ng).

expose_grid_([H|T], G, Ng) :- % is a space, recurse
	grid_val_xy(G, H, cell('.',0)),
	grid_set_xy(G, H, cell(0,0), Ng1),
	expose_grid(H, Ng1, Ng2),
	expose_grid_(T, Ng2, Ng).
