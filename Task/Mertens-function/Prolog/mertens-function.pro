:- dynamic mertens_number_cache/2.

mertens_number(1, 1):- !.
mertens_number(N, M):-
    mertens_number_cache(N, M),
    !.
mertens_number(N, M):-
    N >= 2,
    mertens_number(N, 2, M, 0),
    assertz(mertens_number_cache(N, M)).

mertens_number(N, N, M, M):- !.
mertens_number(N, K, M, S):-
    N1 is N // K,
    mertens_number(N1, M1),
    K1 is K + 1,
    S1 is S - M1,
    mertens_number(N, K1, M, S1).

print_mertens_numbers(Count):-
    print_mertens_numbers(Count, 0).

print_mertens_numbers(Count, Count):-!.
print_mertens_numbers(Count, N):-
    (N == 0 ->
        write('   ')
        ;
        mertens_number(N, M),
        writef('%3r', [M])
    ),
    N1 is N + 1,
    Column is N1 mod 20,
    (N > 0, Column == 0 ->
        nl
        ;
        true
    ),
    print_mertens_numbers(Count, N1).

count_zeros(From, To, Z, C):-
    count_zeros(From, To, Z, C, 0, 0, 0).

count_zeros(From, To, Z, C, Z, C, _):-
    From > To,
    !.
count_zeros(From, To, Z, C, Z1, C1, P):-
    mertens_number(From, M),
    (M == 0 -> Z2 is Z1 + 1 ; Z2 = Z1),
    (M == 0, P \= 0 -> C2 is C1 + 1 ; C2 = C1),
    Next is From + 1,
    count_zeros(Next, To, Z, C, Z2, C2, M).

main:-
    writeln('First 199 Mertens numbers:'),
    print_mertens_numbers(200),
    count_zeros(1, 1000, Z, C),
    writef('M(n) is zero %t times for 1 <= n <= 1000.\n', [Z]),
    writef('M(n) crosses zero %t times for 1 <= n <= 1000.\n', [C]).
