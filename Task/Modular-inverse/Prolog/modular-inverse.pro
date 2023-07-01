egcd(_, 0, 1, 0) :- !.
egcd(A, B, X, Y) :-
    divmod(A, B, Q, R),
    egcd(B, R, S, X),
    Y is S - Q*X.

modinv(A, B, N) :-
    egcd(A, B, X, Y),
    A*X + B*Y =:= 1,
    N is X mod B.
