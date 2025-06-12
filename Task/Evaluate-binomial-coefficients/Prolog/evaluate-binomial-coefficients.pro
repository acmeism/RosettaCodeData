binomial(N, K, 0) :- K > N.
binomial(N, K, X) :- binomial_helper(1, 1, K, N, X).

binomial_helper(R, D, K, _, R) :- D > K, !.
binomial_helper(R, D, K, N, X) :-
    D =< K,
    R1 is R * N / D,
    D1 is D + 1,
    N1 is N - 1,
    binomial_helper(R1, D1, K, N1, X).
