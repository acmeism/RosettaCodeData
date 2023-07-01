?- use_module(library(primality)).

circular(N) :- member(N, [2, 3, 5, 7]).
circular(N) :-
    limit(15, (
        candidate(N),
        N > 9,
        circular_prime(N))).
circular(r(K)) :-
    between(6, inf, K),
    N is (10**K - 1) div 9,
    prime(N).

candidate(0).
candidate(N) :-
    candidate(M),
    member(D, [1, 3, 7, 9]),
    N is 10*M + D.

circular_prime(N) :-
    K is floor(log10(N)) + 1,
    circular_prime(N, N, K).
circular_prime(_, _, 0) :- !.
circular_prime(P0, P, K) :-
   P >= P0,
   prime(P),
   rotate(P, Q), succ(DecK, K),
   circular_prime(P0, Q, DecK).

rotate(N, M) :-
    D is floor(log10(N)),
    divmod(N, 10, Q, R),
    M is R*10**D + Q.

main :-
    findall(P, limit(23, circular(P)), S),
    format("The first 23 circular primes:~n~w~n", [S]),
    halt.

?- main.
