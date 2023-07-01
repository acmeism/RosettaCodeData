main:-
    between(1, 40, N),
    min_mult_dsum(N, M),
    writef('%6r', [M]),
    (0 is N mod 10 -> nl ; true),
    fail.
main.

min_mult_dsum(N, M):-
    min_mult_dsum(N, 1, M).

min_mult_dsum(N, M, M):-
    P is M * N,
    digit_sum(P, N),
    !.
min_mult_dsum(N, K, M):-
    L is K + 1,
    min_mult_dsum(N, L, M).

digit_sum(N, Sum):-
    digit_sum(N, Sum, 0).

digit_sum(N, Sum, S1):-
    N < 10,
    !,
    Sum is S1 + N.
digit_sum(N, Sum, S1):-
    divmod(N, 10, M, Digit),
    S2 is S1 + Digit,
    digit_sum(M, Sum, S2).
