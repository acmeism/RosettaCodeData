add(A,B,R):-
    R is A + B.

mul(A,B,R):-
    R is A * B.

% define fold now.
fold([], Act, Init, Init).

fold(Lst, Act, Init, Res):-
    head(Lst,Hd),
    tail(Lst,Tl),
    apply(Act,[Init, Hd, Ra]),
    fold(Tl, Act, Ra, Res).

sumproduct(Lst, Sum, Prod):-
    fold(Lst,mul,1, Prod),
    fold(Lst,add,0, Sum).

?- sumproduct([1,2,3,4],Sum,Prod).
Sum = 10,
Prod = 24 .
