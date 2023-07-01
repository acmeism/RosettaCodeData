find_solutions(Limit, Solutions):-
    find_solutions(Limit, Solutions, Limit, []).

find_solutions(_, S, 0, S):-
    !.
find_solutions(Limit, Solutions, A, S):-
    find_solutions1(Limit, A, A, S1, S),
    A_next is A - 1,
    find_solutions(Limit, Solutions, A_next, S1).

find_solutions1(Limit, _, B, Triples, Triples):-
    B > Limit,
    !.
find_solutions1(Limit, A, B, [Triple|Triples], T):-
    is_solution(Limit, A, B, Triple),
    !,
    B_next is B + 1,
    find_solutions1(Limit, A, B_next, Triples, T).
find_solutions1(Limit, A, B, Triples, T):-
    B_next is B + 1,
    find_solutions1(Limit, A, B_next, Triples, T).

is_solution(Limit, A, B, t(Angle, A, B, C)):-
    X is A * A + B * B,
    Y is A * B,
    (
        Angle = 90, C is round(sqrt(X)), X is C * C
        ;
        Angle = 120, C2 is X + Y, C is round(sqrt(C2)), C2 is C * C
        ;
        Angle = 60, C2 is X - Y, C is round(sqrt(C2)), C2 is C * C
    ),
    C =< Limit,
    !.

write_triples(Angle, Solutions):-
    find_triples(Angle, Solutions, List, 0, Count),
    writef('There are %w solutions for gamma = %w:\n', [Count, Angle]),
    write_triples1(List),
    nl.

find_triples(_, [], [], Count, Count):-
    !.
find_triples(Angle, [Triple|Triples], [Triple|Result], C, Count):-
    Triple = t(Angle, _, _, _),
    !,
    C1 is C + 1,
    find_triples(Angle, Triples, Result, C1, Count).
find_triples(Angle, [_|Triples], Result, C, Count):-
    find_triples(Angle, Triples, Result, C, Count).

write_triples1([]):-!.
write_triples1([t(_, A, B, C)]):-
    writef('(%w,%w,%w)\n', [A, B, C]),
    !.
write_triples1([t(_, A, B, C)|Triples]):-
    writef('(%w,%w,%w) ', [A, B, C]),
    write_triples1(Triples).

main:-
    find_solutions(13, Solutions),
    write_triples(60, Solutions),
    write_triples(90, Solutions),
    write_triples(120, Solutions).
