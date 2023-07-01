while(0) :- !.
while(X) :-
    writeln(X),
    X1 is X // 2,
    while(X1).
