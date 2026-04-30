% map_range(+S, +A1, +A2, +B1, +B2, -R)
map_range(S, A1, A2, B1, B2, R) :-
    R is B1 + (S - A1) * (B2 - B1) / (A2 - A1).

% bucle principal
run :-
    forall(between(0, 10, I),
           ( map_range(I, 0, 10, -1, 0, R),
             format("~w maps to ~1f~n", [I, R])
           )).
