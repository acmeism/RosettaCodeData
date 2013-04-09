line1(X):- line2(X),write(' on the wall').
line2(0):- write('no more bottles of beer').
line2(1):- write('1 bottle of beer').
line2(X):- writef('%t bottles of beer',[X]).
line3(1):- write('Take it down, pass it around').
line3(X):- write('Take one down, pass it around').
line4(X):- line1(X).

bottles(0):-!.
bottles(X):-	
    succ(XN,X),
    line1(X),nl,
    line2(X),nl,
    line3(X),nl,
    line4(XN),nl,nl,
    !,
    bottles(XN).

:- bottles(99).
