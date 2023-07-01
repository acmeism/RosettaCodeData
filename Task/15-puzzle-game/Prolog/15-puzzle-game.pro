% map the sequence of cells
next_cell(1,Y,2,Y).
next_cell(2,Y,3,Y).
next_cell(3,Y,4,Y).
next_cell(4,1,1,2).
next_cell(4,2,1,3).
next_cell(4,3,1,4).

% map the game items, and how to print	
item(1,2,   '  1 ').
item(2,3,   '  2 ').
item(3,4,   '  3 ').
item(4,5,   '  4 ').
item(5,6,   '  5 ').
item(6,7,   '  6 ').
item(7,8,   '  7 ').
item(8,9,   '  8 ').
item(9,10,  '  9 ').
item(10,11, ' 10 ').
item(11,12, ' 11 ').
item(12,13, ' 12 ').
item(13,14, ' 13 ').
item(14,15, ' 14 ').
item(15,0,  ' 15 ').

% Move - find the current blank space, and the new place and swap them
move_1(1,2).
move_1(2,3).
move_1(3,4).

move(up, X, Y, X, Y1) :- move_1(Y1,Y).
move(down, X, Y, X, Y1) :- move_1(Y, Y1).
move(left, X, Y, X1, Y) :- move_1(X1, X).
move(right, X, Y, X1, Y) :- move_1(X, X1).

move(Dir, Board, [p(X1,Y1,0),p(X,Y,P)|B2]) :-
    select(p(X, Y, 0), Board, B1),
    move(Dir, X,Y,X1,Y1),
    select(p(X1, Y1, P), B1, B2).

% Solved - the game is solved if running through the next_cell sequence produces the item sequence.
solved(Board) :-
    select(p(1,1,1),Board,Remaining),
    solved(Remaining,p(1,1,1)).
solved([p(4,4,0)], p(_,_,15)).
solved(Board,p(Xp,Yp,Prev)) :-
    item(Prev,P,_),
    select(p(X,Y,P),Board,Remaining),
    next_cell(Xp,Yp,X,Y),
    solved(Remaining, p(X,Y,P)).

% Print - run through the next_cell sequence printing the found items.
print(Board) :-
    select(p(1,1,P),Board,Remaining),
    nl, write_cell(P),
    print(Remaining,p(1,1)).
print([],_) :- nl.
print(Board,p(X,Y)) :-
    next_cell(X,Y,X1,Y1),
    select(p(X1,Y1,P),Board,Remaining),
    write_cell(P),
    end_line_or_not(X1),
    print(Remaining,p(X1,Y1)).

write_cell(0) :- write('    ').	
write_cell(P) :- item(P,_,W), write(W).

end_line_or_not(1).
end_line_or_not(2).
end_line_or_not(3).
end_line_or_not(4) :- nl.

% Next Move - get the player input.
next_move_by_player(Move) :-
    repeat,
    get_single_char(Char),
    key_move(Char, Move).

key_move(119, up).    % 'w'
key_move(115, down).  % 'd'	
key_move(97, left).   % 'a'
key_move(100, right). % 'd'

% Play - loop over the player moves until solved.
play(Board) :-
    solved(Board) -> (
        print(Board),
        write('You Win!\n'))
    ; (
        print(Board),
        next_move_by_player(Move),
        move(Move, Board, NewBoard),
        play(NewBoard)).

play :-
   test_board(Board),
   play(Board),
   !.

test_board(
   [p(1,1,9),p(2,1,1),p(3,1,4),p(4,1,7),
    p(1,2,6),p(2,2,5),p(3,2,3),p(4,2,2),
    p(1,3,13),p(2,3,10),p(3,3,0),p(4,3,8),
    p(1,4,14),p(2,4,15),p(3,4,11),p(4,4,12)]).
