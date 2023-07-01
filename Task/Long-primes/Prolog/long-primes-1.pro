% See https://en.wikipedia.org/wiki/Full_reptend_prime
long_prime(Prime):-
    is_prime(Prime),
    M is 10 mod Prime,
    M > 1,
    primitive_root(10, Prime).

% See https://en.wikipedia.org/wiki/Primitive_root_modulo_n#Finding_primitive_roots
primitive_root(Base, Prime):-
    Phi is Prime - 1,
    primitive_root(Phi, 2, Base, Prime).

primitive_root(1, _, _, _):-!.
primitive_root(N, P, Base, Prime):-
    is_prime(P),
    0 is N mod P,
    !,
    X is (Prime - 1) // P,
    R is powm(Base, X, Prime),
    R \= 1,
    divide_out(N, P, M),
    Q is P + 1,
    primitive_root(M, Q, Base, Prime).
primitive_root(N, P, Base, Prime):-
    Q is P + 1,
    Q * Q < Prime,
    !,
    primitive_root(N, Q, Base, Prime).
primitive_root(N, _, Base, Prime):-
    X is (Prime - 1) // N,
    R is powm(Base, X, Prime),
    R \= 1.

divide_out(N, P, M):-
    divmod(N, P, Q, 0),
    !,
    divide_out(Q, P, M).
divide_out(N, _, N).

print_long_primes([], _):-
    !,
    nl.
print_long_primes([Prime|_], Limit):-
    Prime > Limit,
    !,
    nl.
print_long_primes([Prime|Primes], Limit):-
    writef('%w ', [Prime]),
    print_long_primes(Primes, Limit).

count_long_primes(_, L, Limit, _):-
    L > Limit,
    !.
count_long_primes([], Limit, _, Count):-
    writef('Number of long primes up to %w: %w\n', [Limit, Count]),
    !.
count_long_primes([Prime|Primes], L, Limit, Count):-
    Prime > L,
    !,
    writef('Number of long primes up to %w: %w\n', [L, Count]),
    Count1 is Count + 1,
    L1 is L * 2,
    count_long_primes(Primes, L1, Limit, Count1).
count_long_primes([_|Primes], L, Limit, Count):-
    Count1 is Count + 1,
    count_long_primes(Primes, L, Limit, Count1).

main(Limit):-
    find_prime_numbers(Limit),
    findall(Prime, long_prime(Prime), Primes),
    writef('Long primes up to 500:\n'),
    print_long_primes(Primes, 500),
    count_long_primes(Primes, 500, Limit, 0).

main:-
    main(256000).
