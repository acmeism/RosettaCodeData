show(Count) :-
    findall(N, limit(Count, (between(2, infinite, N), mersenne_prime(N))), S),
    forall(member(P, S), (write(P), write(" "))), nl.

lucas_lehmer_seq(M, L) :-
    lazy_list(ll_iter, 4-M, L).

ll_iter(S-M, T-M, T) :-
    T is ((S*S) - 2) mod M.

drop(N, Lz1, Lz2) :-
    append(Pfx, Lz2, Lz1), length(Pfx, N), !.

mersenne_prime(2).
mersenne_prime(P) :-
    P > 2,
    prime(P),
    M is (1 << P) - 1,
    lucas_lehmer_seq(M, Residues),
    Skip is P - 3, drop(Skip, Residues, [R|_]),
    R =:= 0.

% check if a number is prime
%
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
