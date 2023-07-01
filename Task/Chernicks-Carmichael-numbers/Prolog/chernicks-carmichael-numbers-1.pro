?- use_module(library(primality)).

u(3, M, A * B * C) :-
    A is 6*M + 1, B is 12*M + 1, C is 18*M + 1, !.
u(N, M, U0 * D) :-
    succ(Pn, N), u(Pn, M, U0),
    D is 9*(1 << (N - 2))*M + 1.

prime_factorization(A*B) :- prime(B), prime_factorization(A), !.
prime_factorization(A) :- prime(A).

step(N, 1) :- N < 5, !.
step(5, 2) :- !.
step(N, K) :- K is 5*(1 << (N - 4)).

a(N, Factors) :- % due to backtracking nature of Prolog, a(n) will return all chernick-carmichael numbers.
    N > 2, !,
    step(N, I),
    between(1, infinite, J), M is I * J,
    u(N, M, Factors),
    prime_factorization(Factors).

main :-
    forall(
        (between(3, 9, K), once(a(K, Factorization)), N is Factorization),
        format("~w: ~w = ~w~n", [K, Factorization, N])),
    halt.

?- main.
