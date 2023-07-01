% Find the square root as a continued fraction

cf_sqrt(N, Sz, [A0, Frac]) :-
    A0 is floor(sqrt(N)),
    (A0*A0 =:= N ->
        Sz = 0, Frac = []
    ;
        cf_sqrt(N, A0, A0, 0, 1, 0, [], Sz, Frac)).

cf_sqrt(N, A, A0, M0, D0, Sz0, L, Sz, R) :-
    M1 is D0*A0 - M0,
    D1 is (N - M1*M1) div D0,
    A1 is (A + M1) div D1,
    (A1 =:= 2*A ->
        succ(Sz0, Sz), revtl([A1|L], R, R)
    ;
        succ(Sz0, Sz1), cf_sqrt(N, A, A1, M1, D1, Sz1, [A1|L], Sz, R)).

revtl([], Z, Z).
revtl([A|As], Bs, Z) :- revtl(As, [A|Bs], Z).


% evaluate an infinite continued fraction as a lazy list of convergents.
%
convergents([A0, As], Lz) :-
    lazy_list(next_convergent, eval_state(1, 0, A0, 1, As), Lz).

next_convergent(eval_state(P0, Q0, P1, Q1, [Term|Ts]), eval_state(P1, Q1, P2, Q2, Ts), R) :-
    P2 is Term*P1 + P0,
    Q2 is Term*Q1 + Q0,
    R is P1 rdiv Q1.


% solve Pell's equation
%
pell(N, X, Y) :-
    cf_sqrt(N, _, D), convergents(D, Rs),
    once((member(R, Rs), ratio(R, P, Q), P*P - N*Q*Q =:= 1)),
    pell_seq(N, P, Q, X, Y).

ratio(N, N, 1) :- integer(N).
ratio(P rdiv Q, P, Q).

pell_seq(_, X, Y, X, Y).
pell_seq(N, X0, Y0, X2, Y2) :-
    pell_seq(N, X0, Y0, X1, Y1),
    X2 is X0*X1 + N*Y0*Y1,
    Y2 is X0*Y1 + Y0*X1.
