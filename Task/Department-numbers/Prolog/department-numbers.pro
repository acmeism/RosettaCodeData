dept(X) :- between(1, 7, X).

police(X) :- member(X, [2, 4, 6]).
fire(X)   :- dept(X).
san(X)    :- dept(X).

assign(A, B, C) :-
    police(A), fire(B), san(C),
    A =\= B, A =\= C, B =\= C,
    12 is A + B + C.

main :-
    write("P F S"), nl,
    forall(assign(Police, Fire, Sanitation), format("~w ~w ~w~n", [Police, Fire, Sanitation])),
    halt.

?- main.
