prime(N) :-
    integer(N),
    N > 1,
    divcheck(
        N,
        [  2,   3,   5,   7,  11,  13,  17,  19,  23,  29,  31,
          37,  41,  43,  47,  53,  59,  61,  67,  71,  73,  79,
          83,  89,  97, 101, 103, 107, 109, 113, 127, 131, 137,
         139, 149],
        Result),
    ((Result = prime, !); miller_rabin_primality_test(N)).

divcheck(_, [],    unknown) :- !.
divcheck(N, [P|_], prime) :- P*P > N, !.
divcheck(N, [P|Ps], State) :- N mod P =\= 0, divcheck(N, Ps, State).

miller_rabin_primality_test(N) :-
    bases(Bases, N),
    forall(member(A, Bases), strong_fermat_pseudoprime(N, A)).

miller_rabin_precision(16).

bases([31, 73], N) :- N < 9_080_191, !.
bases([2, 7, 61], N) :- N < 4_759_123_141, !.
bases([2, 325, 9_375, 28_178, 450_775, 9_780_504, 1_795_265_022], N) :-
    N < 18_446_744_073_709_551_616, !. % 2^64
bases(Bases, N) :-
    miller_rabin_precision(T), RndLimit is N - 2,
    length(Bases, T), maplist(random_between(2, RndLimit), Bases).

strong_fermat_pseudoprime(N, A) :-  % miller-rabin strong pseudoprime test with base A.
    succ(Pn, N), factor_2s(Pn, S, D),
    X is powm(A, D, N),
    ((X =:= 1, !); \+ composite_witness(N, S, X)).

composite_witness(_, 0, _) :- !.
composite_witness(N, K, X) :-
    X =\= N-1,
    succ(Pk, K), X2 is (X*X) mod N, composite_witness(N, Pk, X2).

factor_2s(N, S, D) :- factor_2s(0, N, S, D).
factor_2s(S, D, S, D) :- D /\ 1 =\= 0, !.
factor_2s(S0, D0, S, D) :-
    succ(S0, S1), D1 is D0 >> 1,
    factor_2s(S1, D1, S, D).
