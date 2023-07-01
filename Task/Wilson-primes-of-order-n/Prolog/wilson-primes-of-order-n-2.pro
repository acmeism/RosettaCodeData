:- module(prime_numbers, [find_prime_numbers/1, is_prime/1]).
:- dynamic is_prime/1.

find_prime_numbers(N):-
    retractall(is_prime(_)),
    assertz(is_prime(2)),
    init_sieve(N, 3),
    sieve(N, 3).

init_sieve(N, P):-
    P > N,
    !.
init_sieve(N, P):-
    assertz(is_prime(P)),
    Q is P + 2,
    init_sieve(N, Q).

sieve(N, P):-
    P * P > N,
    !.
sieve(N, P):-
    is_prime(P),
    !,
    S is P * P,
    cross_out(S, N, P),
    Q is P + 2,
    sieve(N, Q).
sieve(N, P):-
    Q is P + 2,
    sieve(N, Q).

cross_out(S, N, _):-
    S > N,
    !.
cross_out(S, N, P):-
    retract(is_prime(S)),
    !,
    Q is S + 2 * P,
    cross_out(Q, N, P).
cross_out(S, N, P):-
    Q is S + 2 * P,
    cross_out(Q, N, P).
