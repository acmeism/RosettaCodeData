makepowers :-
    retractall(pow5(_, _)),
    between(1, 249, X),
    Y is X * X * X * X * X,
    assert(pow5(X, Y)),
    fail.
makepowers.

within(A, Bx, N) :-  % like between but with an exclusive upper bound
   succ(B, Bx),
   between(A, B, N).

solution(X0, X1, X2, X3, Y) :-
    makepowers,
    within(4, 250, X0), pow5(X0, X0_5th),
    within(3, X0,  X1), pow5(X1, X1_5th),
    within(2, X1,  X2), pow5(X2, X2_5th),
    within(1, X2,  X3), pow5(X3, X3_5th),
    Y_5th is X0_5th + X1_5th + X2_5th + X3_5th,
    pow5(Y, Y_5th).
