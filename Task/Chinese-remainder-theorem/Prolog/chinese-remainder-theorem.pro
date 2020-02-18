product(A, B, C) :- C is A*B.

pair(X, Y, X-Y).

egcd(_, 0, 1, 0) :- !.
egcd(A, B, X, Y) :-
    divmod(A, B, Q, R),
    egcd(B, R, S, X),
    Y is S - Q*X.

modinv(A, B, X) :-
    egcd(A, B, X, Y),
    A*X + B*Y =:= 1.

crt_fold(A, M, P, R0, R1) :- % system of equations of (x = a) (mod m); p = M/m
    modinv(P, M, Inv),
    R1 is R0 + A*Inv*P.

crt(Pairs, N) :-
    maplist(pair, As, Ms, Pairs),
    foldl(product, Ms, 1, M),
    maplist(divmod(M), Ms, Ps, _), % p(n) <- M/m(n)
    foldl(crt_fold, As, Ms, Ps, 0, N0),
    N is N0 mod M.
