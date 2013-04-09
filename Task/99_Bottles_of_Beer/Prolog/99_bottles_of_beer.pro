bottles(0):-!.
bottles(X):-
    writef('%t bottles of beer on the wall \n',[X]),
    writef('%t bottles of beer\n',[X]),
    write('Take one down, pass it around\n'),
    succ(XN,X),
    writef('%t bottles of beer on the wall \n\n',[XN]),
    bottles(XN).

:- bottles(99).
