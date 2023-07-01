mersenne_factor(P, F) :-
    prime(P),
    once((
        between(1, 100_000, K),  % Fail if we can't find a small factor
        Q is 2*K*P + 1,
        test_factor(Q, P, F))).

test_factor(Q, P, prime) :- Q*Q > (1 << P - 1), !.
test_factor(Q, P, Q) :-
    R is Q /\ 7, member(R, [1, 7]),
    prime(Q),
    powm(2, P, Q) =:= 1.


wheel235(L) :-
   W = [4, 2, 4, 2, 4, 6, 2, 6 | W],
   L = [1, 2, 2 | W].

prime(N) :-
   N >= 2,
   wheel235(W),
   prime(N, 2, W).

prime(N, D, _) :- D*D > N, !.
prime(N, D, [A|As]) :-
    N mod D =\= 0,
    D2 is D + A, prime(N, D2, As).
