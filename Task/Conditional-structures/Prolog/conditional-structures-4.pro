fact(X) :-
    (   X = bar ->  write('You got me!'), nl
    ;               write(X), write(' is not right!'), nl, fail ).

go :-
    (   fact(booger)
    ;   fact(bar) ).
