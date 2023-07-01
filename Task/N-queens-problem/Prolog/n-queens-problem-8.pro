:- use_module(library(clpfd)).

% DOC: http://www.pathwayslms.com/swipltuts/clpfd/clpfd.html
length_(Length, List) :- length(List, Length).

applyConstraints([]).
applyConstraints([ Q | Queens ]) :-
    checkConstraints(Q, Queens),
    applyConstraints(Queens).

checkConstraints(_, []).
checkConstraints([Row0, Col0], [ [Row1, Col1] | Queens]) :-
    Row0 #\= Row1,                 % No two queens on same row
    Col0 #\= Col1,                 % No two queens on same columns
    Row0 + Col0 #\= Row1 + Col1,   % Down diagonals: [8,1], [7,2], [6,3]
    Row0 - Col0 #\= Row1 - Col1,   % Up   diagonals: [1,1], [2,2], [3,3]
    checkConstraints([Row0,Col0], Queens).


% Optimization: pre-assign each queen to a named row
optimizeQueens(Queens) :- optimizeQueens(Queens, 1).
optimizeQueens([],_).
optimizeQueens([[Row,_] | Queens], Index) :-
    Row #= Index,
    NextIndex is Index + 1,
    optimizeQueens(Queens, NextIndex).


nqueens(N, Queens) :-
    % Function Preconditions
    N > 0,

    % Create 2D Datastructure for Queens
    length(Queens, N), maplist(length_(2), Queens),
    flatten(Queens, QueenArray),

    % Queens coords must be in range
    QueenArray ins 1..N,

    % Apply Constraints
    optimizeQueens(Queens),
    applyConstraints(Queens),

    % Solve
    label(QueenArray),
    true.


all_nqueens(N) :- all_nqueens(N, _).
all_nqueens(N, Solutions) :-
    findall(Queens, (nqueens(N,Queens), write(Queens), nl), Solutions),
    length(Solutions,Count),
    write(Count), write(' solutions'), nl,
    Count #>= 1.


print_nqueens_all(N)                 :- all_nqueens(N, Solutions), print_nqueens(N, Solutions).
print_nqueens(N)                     :- nqueens(N, Queens),        print_board(N, Queens).
print_nqueens(N, [Queens|Remaining]) :- print_count(Remaining),    print_board(N, Queens),    print_nqueens(N, Remaining).
print_nqueens(_, []).

print_count(Remaining) :- length(Remaining, Count), Count1 is Count + 1, nl, write('# '), write(Count1), nl.
print_board(N, [[_,Q] | Queens]) :- print_line(N, '-'), print_line(N, '|', Q), print_board(N, Queens).
print_board(N, [])  :- print_line(N, '-').
print_line(0,'-')   :- write('-'), nl.
print_line(N,'-')   :- write('----'), N1 is N-1, print_line(N1,'-').
print_line(0,'|',_) :- write('|'), nl.
print_line(N,'|',Q) :- write('|'), (( Q == N ) -> write(' Q ') ; write('   ')), N1 is N-1, print_line(N1,'|',Q).

%:- initialization main.
main :-
    print_nqueens_all(8).
