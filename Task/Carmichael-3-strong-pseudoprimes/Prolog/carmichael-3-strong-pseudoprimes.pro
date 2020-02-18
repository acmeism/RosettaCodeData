show(Limit) :-
    forall(
        carmichael(Limit, P1, P2, P3, C),
        format("~w * ~w * ~w ~t~20| = ~w~n", [P1, P2, P3, C])).

carmichael(Upto, P1, P2, P3, X) :-
    between(2, Upto, P1),
    prime(P1),
    Limit is P1 - 1, between(2, Limit, H3),
    MaxD is H3 + P1 - 1, between(1, MaxD, D),
    (H3 + P1)*(P1 - 1) mod D =:= 0,
    -P1*P1 mod H3 =:= D mod H3,
    P2 is 1 + (P1 - 1)*(H3 + P1) div D,
    prime(P2),
    P3 is 1 + P1*P2 div H3,
    prime(P3),
    X is P1*P2*P3.

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
