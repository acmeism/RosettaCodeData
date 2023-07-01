main:-
    print_harmonic_series(20),
    nl,
    nth_harmonic_number(100, T),
    Num is numerator(T),
    Denom is denominator(T),
    writef('100th harmonic number: %t/%t\n', [Num, Denom]),
    nl,
    print_first_harmonic_greater_than(10).

print_harmonic_series(N):-
    writef('First %t harmonic numbers:\n', [N]),
    harmonic_first(H),
    print_harmonic_series(N, H).

print_harmonic_series(N, H):-
    H = h(I, T),
    Num is numerator(T),
    Denom is denominator(T),
    writef('%3r. %t/%t\n', [I, Num, Denom]),
    (I == N, ! ; harmonic_next(H, H1), print_harmonic_series(N, H1)).

print_first_harmonic_greater_than(N):-
    harmonic_first(H),
    print_first_harmonic_greater_than(1, N, H).

print_first_harmonic_greater_than(N, L, _):-
    N > L,
    !.
print_first_harmonic_greater_than(N, L, H):-
    H = h(P, T),
    (T > N ->
        writef('Position of first term >%3r: %t\n', [N, P]),
        N1 is N + 1
        ;
        N1 = N),
    harmonic_next(H, H1),
    print_first_harmonic_greater_than(N1, L, H1).

harmonic_first(h(1, 1)).

harmonic_next(h(N1, T1), h(N2, T2)):-
    N2 is N1 + 1,
    T2 is T1 + 1 rdiv N2.

nth_harmonic_number(N, T):-
    harmonic_first(H),
    nth_harmonic_number(N, T, H).

nth_harmonic_number(N, T, h(N, T)):-!.
nth_harmonic_number(N, T, H1):-
    harmonic_next(H1, H2),
    nth_harmonic_number(N, T, H2).
