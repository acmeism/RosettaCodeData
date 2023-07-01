:- dynamic fusc_cache/2.

fusc(0, 0):-!.
fusc(1, 1):-!.
fusc(N, F):-
    fusc_cache(N, F),
    !.
fusc(N, F):-
    0 is N mod 2,
    !,
    M is N//2,
    fusc(M, F),
    assertz(fusc_cache(N, F)).
fusc(N, F):-
    N1 is (N - 1)//2,
    N2 is (N + 1)//2,
    fusc(N1, F1),
    fusc(N2, F2),
    F is F1 + F2,
    assertz(fusc_cache(N, F)).

print_fusc_sequence(N):-
    writef('First %w fusc numbers:\n', [N]),
    print_fusc_sequence(N, 0),
    nl.

print_fusc_sequence(N, M):-
    M >= N,
    !.
print_fusc_sequence(N, M):-
    fusc(M, F),
    writef('%w ', [F]),
    M1 is M + 1,
    print_fusc_sequence(N, M1).

print_max_fusc(N):-
    writef('Fusc numbers up to %w that are longer than any previous one:\n', [N]),
    print_max_fusc(N, 0, 0).

print_max_fusc(N, M, _):-
    M >= N,
    !.
print_max_fusc(N, M, Max):-
    fusc(M, F),
    (F >= Max ->
        writef('n = %w, fusc(n) = %w\n', [M, F]), Max1 = max(10, Max * 10)
        ;
        Max1 = Max
    ),
    M1 is M + 1,
    print_max_fusc(N, M1, Max1).

main:-
    print_fusc_sequence(61),
    print_max_fusc(1000000).
