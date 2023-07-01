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

digital_root(N, Base, AP, DR):-
    digital_root(N, Base, AP, DR, 0).

digital_root(N, Base, AP, N, AP):-
    N < Base,
    !.
digital_root(N, Base, AP, DR, AP1):-
    digit_sum(N, Base, Sum),
    AP2 is AP1 + 1,
    digital_root(Sum, Base, AP, DR, AP2).

test_digital_root(N, Base):-
    digital_root(N, Base, AP, DR),
    writef('%w has additive persistence %w and digital root %w.\n', [N, AP, DR]).

main:-
    test_digital_root(627615, 10),
    test_digital_root(39390, 10),
    test_digital_root(588225, 10),
    test_digital_root(393900588225, 10),
    test_digital_root(685943443231217865409, 10).
