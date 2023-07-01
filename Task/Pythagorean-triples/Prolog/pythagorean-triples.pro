show :-
    Data = [100, 1_000, 10_000, 100_000, 1_000_000, 10_000_000, 100_000_000],
    forall(
        member(Max, Data),
        (count_triples(Max, Total, Prim),
         format("upto ~D, there are ~D Pythagorean triples (~D primitive.)~n", [Max, Total, Prim]))).

div(A, B, C) :- C is A div B.

count_triples(Max, Total, Prims) :-
    findall(S, (triple(Max, A, B, C), S is A + B + C), Ps),
    length(Ps, Prims),
    maplist(div(Max), Ps, Counts), sumlist(Counts, Total).

% - between_by/4

between_by(A, B, N, K) :-
    C is (B - A) div N,
    between(0, C, J),
    K is N*J + A.

% - Pythagorean triple generator

triple(P, A, B, C) :-
    Max is floor(sqrt(P/2)) - 1,
    between(0, Max, M),
    Start is (M /\ 1) + 1, succ(Pm, M),
    between_by(Start, Pm, 2, N),
    gcd(M, N) =:= 1,
    X is M*M - N*N,
    Y is 2*M*N,
    C is M*M + N*N,
    order2(X, Y, A, B),
    (A + B + C) =< P.

order2(A, B, A, B) :- A < B, !.
order2(A, B, B, A).
