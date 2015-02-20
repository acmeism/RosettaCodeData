halve(X,Y) :- Y is X // 2.
double(X,Y) :- Y is 2*X.
is_even(X) :- 0 is X mod 2.

% columns(First,Second,Left,Right) is true if integers First and Second
% expand into the columns Left and Right, respectively
columns(1,Second,[1],[Second]).
columns(First,Second,[First|Left],[Second|Right]) :-
    halve(First,Halved),
    double(Second,Doubled),
    columns(Halved,Doubled,Left,Right).

% contribution(Left,Right,Amount) is true if integers Left and Right,
% from their respective columns contribute Amount to the final sum.
contribution(Left,_Right,0) :-
    is_even(Left).
contribution(Left,Right,Right) :-
    \+ is_even(Left).

ethiopian(First,Second,Product) :-
    columns(First,Second,Left,Right),
    maplist(contribution,Left,Right,Contributions),
    sumlist(Contributions,Product).
