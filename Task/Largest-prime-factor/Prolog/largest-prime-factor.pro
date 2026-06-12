wheel2357(L) :-
   W = [2,  4,  2,  4,  6,  2,  6,  4,
        2,  4,  6,  6,  2,  6,  4,  2,
        6,  4,  6,  8,  4,  2,  4,  2,
        4,  8,  6,  4,  6,  2,  4,  6,
        2,  6,  6,  4,  2,  4,  6,  2,
        6,  4,  2,  4,  2, 10,  2, 10 | W],
   L = [1, 2, 2, 4 | W].

gpf(N, P) :-  % greatest prime factor
   wheel2357(W),
   gpf(N, 2, W, P).

gpf(N, D, _, N) :- D*D > N, !.
gpf(N, D, W, X) :-
   N mod D =:= 0, !,
   N2 is N/D,
   gpf(N2, D, W, X).
gpf(N, D, [S|Ss], X) :-
   plus(D, S, D2),
   gpf(N, D2, Ss, X).

main :-
    gpf(600_851_475_143, Euler003),
    format("The largest prime factor of 600,851,475,143 is ~p~n", [Euler003]),
    halt.

?- main.
