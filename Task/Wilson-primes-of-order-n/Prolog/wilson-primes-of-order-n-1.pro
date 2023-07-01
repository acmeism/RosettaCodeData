main:-
    wilson_primes(11000).

wilson_primes(Limit):-
    writeln('  n | Wilson primes\n---------------------'),
    make_factorials(Limit),
    find_prime_numbers(Limit),
    wilson_primes(1, 12, -1).

wilson_primes(N, N, _):-!.
wilson_primes(N, M, S):-
    wilson_primes(N, S),
    S1 is -S,
    N1 is N + 1,
    wilson_primes(N1, M, S1).

wilson_primes(N, S):-
    writef('%3r |', [N]),
    N1 is N - 1,
    factorial(N1, F1),
    is_prime(P),
    P >= N,
    PN is P - N,
    factorial(PN, F2),
    0 is (F1 * F2 - S) mod (P * P),
    writef(' %w', [P]),
    fail.
wilson_primes(_, _):-
    nl.

make_factorials(N):-
    retractall(factorial(_, _)),
    make_factorials(N, 0, 1).

make_factorials(N, N, F):-
    assert(factorial(N, F)),
    !.
make_factorials(N, M, F):-
    assert(factorial(M, F)),
    M1 is M + 1,
    F1 is F * M1,
    make_factorials(N, M1, F1).
