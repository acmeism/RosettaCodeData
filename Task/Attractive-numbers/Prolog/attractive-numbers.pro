prime_factors(N, Factors):-
    S is sqrt(N),
    prime_factors(N, Factors, S, 2).

prime_factors(1, [], _, _):-!.
prime_factors(N, [P|Factors], S, P):-
    P =< S,
    0 is N mod P,
    !,
    M is N // P,
    prime_factors(M, Factors, S, P).
prime_factors(N, Factors, S, P):-
    Q is P + 1,
    Q =< S,
    !,
    prime_factors(N, Factors, S, Q).
prime_factors(N, [N], _, _).

is_prime(2):-!.
is_prime(N):-
    0 is N mod 2,
    !,
    fail.
is_prime(N):-
    N > 2,
    S is sqrt(N),
    \+is_composite(N, S, 3).

is_composite(N, S, P):-
    P =< S,
    0 is N mod P,
    !.
is_composite(N, S, P):-
    Q is P + 2,
    Q =< S,
    is_composite(N, S, Q).

attractive_number(N):-
    prime_factors(N, Factors),
    length(Factors, Len),
    is_prime(Len).

print_attractive_numbers(From, To, _):-
    From > To,
    !.
print_attractive_numbers(From, To, C):-
    (attractive_number(From) ->
        writef('%4r', [From]),
        (0 is C mod 20 -> nl ; true),
        C1 is C + 1
        ;
        C1 = C
    ),
    Next is From + 1,
    print_attractive_numbers(Next, To, C1).

main:-
    print_attractive_numbers(1, 120, 1).
