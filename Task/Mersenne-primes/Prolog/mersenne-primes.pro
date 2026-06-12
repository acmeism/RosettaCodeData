lucas_lehmer_seq(M, L) :-
    lazy_list(ll_iter, 4-M, L).

ll_iter(S-M, T-M, T) :-
    T is ((S*S) - 2) mod M.

drop(N, Lz1, Lz2) :-
    append(Pfx, Lz2, Lz1), length(Pfx, N), !.

mersenne_prime(2).
mersenne_prime(P) :-
    P > 2,
    M is (1 << P) - 1,
    lucas_lehmer_seq(M, Residues),
    Skip is P - 3, drop(Skip, Residues, [R|_]),
    R =:= 0.
