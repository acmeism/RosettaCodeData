digit_sum(N, Base, Sum):-
    digit_sum(N, Base, Sum, 0).

digit_sum(N, Base, Sum, S1):-
    N < Base,
    !,
    Sum is S1 + N.
digit_sum(N, Base, Sum, S1):-
    divmod(N, Base, M, Digit),
    S2 is S1 + Digit,
    digit_sum(M, Base, Sum, S2).

test_digit_sum(N, Base):-
    digit_sum(N, Base, Sum),
    writef('Sum of digits of %w in base %w is %w.\n', [N, Base, Sum]).

main:-
    test_digit_sum(1, 10),
    test_digit_sum(1234, 10),
    test_digit_sum(0xfe, 16),
    test_digit_sum(0xf0e, 16).
