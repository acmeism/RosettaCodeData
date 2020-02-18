iroot(_, 0, 0) :- !.
iroot(M, N, R) :-
    M > 1,
    (N > 0 ->
        irootpos(M, N, R)
    ;
        N /\ 1 =:= 1,
        NegN is -N, irootpos(M, NegN, R0), R is -R0).

irootpos(N, A, R) :-
    X0 is 1 << (msb(A) div N),  % initial guess is 2^(log2(A) / N)
    newton(N, A, X0, X1),
    iroot_loop(A, X1, N, A, R).

iroot_loop(X1, X2, _, _, X1) :- X1 =< X2, !.
iroot_loop(_, X1, N, A, R) :-
    newton(N, A, X1, X2),
    iroot_loop(X1, X2, N, A, R).

newton(2, A, X0, X1) :- X1 is (X0 + A div X0) >> 1, !.  % fast special case
newton(N, A, X0, X1) :- X1 is ((N - 1)*X0 + A div X0**(N - 1)) div N.
