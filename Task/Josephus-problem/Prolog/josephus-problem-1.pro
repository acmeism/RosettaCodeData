josephus(N, K, Survivors) :- josephus(N, K, 1, Survivors).

:- table josephus/4.
josephus(N, K, M, Survivors) :-
    K > 0,
    N > 0,
    N0 is N - 1,
    (   M = N
    ->  numlist(0, N0, Survivors)
    ;   josephus(N0, K, M, Survivors0),
        findall(Survivor, (
            member(Survivor0, Survivors0),
            Survivor is (Survivor0 + K) mod N
        ), Survivors)
    ).
