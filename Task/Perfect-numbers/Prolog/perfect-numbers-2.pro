perfect(N) :-
   factor_2s(N, Chk, Exp),
   Chk =:= (1 << (Exp+1)) - 1,
   prime(Chk).

factor_2s(N, S, D) :- factor_2s(N, 0, S, D).

factor_2s(D, S, D, S) :- getbit(D, 0) =:= 1, !.
factor_2s(N, E, D, S) :-
   E2 is E + 1, N2 is N >> 1, factor_2s(N2, E2, D, S).

% check if a number is prime
%
wheel235(L) :-
   W = [4, 2, 4, 2, 4, 6, 2, 6 | W],
   L = [1, 2, 2 | W].

prime(N) :- N < 2, !, false.
prime(N) :-
   wheel235(W),
   prime(N, 2, W).

prime(N, D, _) :- D*D > N, !.
prime(N, D, _) :- N mod D =:= 0, !, false.
prime(N, D, [A|As]) :- D2 is D + A, prime(N, D2, As).
