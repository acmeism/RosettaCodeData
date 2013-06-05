fib(X) :-
    X=[0,1|Z],
    ffib(Z,X).
ffib(Z,X) :-
    X=[A|Y],
    Y=[B|_],
    N is A+B,
    freeze(Z, (Z=[N|W],ffib(W,Y)) ).
