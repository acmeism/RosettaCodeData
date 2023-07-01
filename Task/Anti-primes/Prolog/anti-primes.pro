divcount(N, Count) :- divcount(N, 1, 0, Count).

divcount(N, D, C, C) :- D*D > N, !.
divcount(N, D, C, Count) :-
    succ(D, D2),
    divs(N, D, A), plus(A, C, C2),
    divcount(N, D2, C2, Count).

divs(N, D, 0) :- N mod D =\= 0, !.
divs(N, D, 1) :- D*D =:= N, !.
divs(_, _, 2).


antiprimes(N, L) :- antiprimes(N, 1, 0, [], L).

antiprimes(0, _, _, L, R) :- reverse(L, R), !.
antiprimes(N, M, Max, L, R) :-
    divcount(M, Count),
    succ(M, M2),
    (Count > Max
        -> succ(N0, N), antiprimes(N0, M2, Count, [M|L], R)
         ; antiprimes(N, M2, Max, L, R)).

main :-
    antiprimes(20, X),
    write("The first twenty anti-primes are "), write(X), nl,
    halt.

?- main.
