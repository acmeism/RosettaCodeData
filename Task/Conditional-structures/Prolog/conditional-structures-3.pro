fact(X) :-
    (   X = foo
    ;   X = bar
    ;   X = baz ).

go :-
    (   fact(booger)
    ;   fact(bar) ).
