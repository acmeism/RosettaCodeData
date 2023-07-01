% See https://en.wikipedia.org/wiki/Divisor_function
divisor_sum(N, Total):-
    divisor_sum_prime(N, 2, 2, Total1, 1, N1),
    divisor_sum(N1, 3, Total, Total1).

divisor_sum(1, _, Total, Total):-
    !.
divisor_sum(N, Prime, Total, Running_total):-
    Prime * Prime =< N,
    !,
    divisor_sum_prime(N, Prime, Prime, P, 1, M),
    Next_prime is Prime + 2,
    Running_total1 is P * Running_total,
    divisor_sum(M, Next_prime, Total, Running_total1).
divisor_sum(N, _, Total, Running_total):-
    Total is (N + 1) * Running_total.

divisor_sum_prime(N, Prime, Power, Total, Running_total, M):-
    0 is N mod Prime,
    !,
    Running_total1 is Running_total + Power,
    Power1 is Power * Prime,
    N1 is N // Prime,
    divisor_sum_prime(N1, Prime, Power1, Total, Running_total1, M).
divisor_sum_prime(N, _, _, Total, Total, N).

% See https://en.wikipedia.org/wiki/Aliquot_sequence
aliquot_sequence(N, Limit, Sequence, Class):-
    aliquot_sequence(N, Limit, [N], Sequence, Class).

aliquot_sequence(_, 0, _, [], 'non-terminating'):-!.
aliquot_sequence(_, _, [0|_], [0], terminating):-!.
aliquot_sequence(N, _, [N, N|_], [], perfect):-!.
aliquot_sequence(N, _, [N, _, N|_], [N], amicable):-!.
aliquot_sequence(N, _, [N|S], [N], sociable):-
    memberchk(N, S),
    !.
aliquot_sequence(_, _, [Term, Term|_], [], aspiring):-!.
aliquot_sequence(_, _, [Term|S], [Term], cyclic):-
    memberchk(Term, S),
    !.
aliquot_sequence(N, Limit, [Term|S], [Term|Rest], Class):-
    divisor_sum(Term, Sum),
    Term1 is Sum - Term,
    L1 is Limit - 1,
    aliquot_sequence(N, L1, [Term1, Term|S], Rest, Class).

write_aliquot_sequence(N, Sequence, Class):-
    writef('%w: %w, sequence:', [N, Class]),
    write_aliquot_sequence(Sequence).

write_aliquot_sequence([]):-
    nl,
    !.
write_aliquot_sequence([Term|Rest]):-
    writef(' %w', [Term]),
    write_aliquot_sequence(Rest).

main:-
    between(1, 10, N),
    aliquot_sequence(N, 16, Sequence, Class),
    write_aliquot_sequence(N, Sequence, Class),
    fail.
main:-
    member(N, [11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488]),
    aliquot_sequence(N, 16, Sequence, Class),
    write_aliquot_sequence(N, Sequence, Class),
    fail.
main.
