wheel2357(L) :-
    W = [2,  4,  2,  4,  6,  2,  6,  4,
         2,  4,  6,  6,  2,  6,  4,  2,
         6,  4,  6,  8,  4,  2,  4,  2,
         4,  8,  6,  4,  6,  2,  4,  6,
         2,  6,  6,  4,  2,  4,  6,  2,
         6,  4,  2,  4,  2, 10,  2, 10 | W],
    L = [1, 2, 2, 4 | W].

factor(1, 1) :- !.
factor(N, Fac) :-
    N > 1,
    wheel2357(W),
    factor(N, 2, W, 1, Fac0),
    reverse_factors(Fac0, Fac).

factor(N, F, _, Fac1, Fac2) :- F*F > N, !, add_factor(N, Fac1, Fac2).
factor(N, F, W, Fac1, Fac) :-
    divmod(N, F, Q, 0), !,
    add_factor(F, Fac1, Fac2),
    factor(Q, F, W, Fac2, Fac).
factor(N, F1, [A|As], Fac1, Fac) :-
    F2 is F1 + A,
    factor(N, F2, As, Fac1, Fac).

add_factor(F, 1, F) :- !.
add_factor(F, F, F**2) :- !.
add_factor(F, F**Ex1, F**Ex2) :- succ(Ex1, Ex2), !.

add_factor(F, F*A, F**2*A) :- !.
add_factor(F, F**Ex1*Rest, F**Ex2*Rest) :- succ(Ex1, Ex2), !.
add_factor(F, Fac, F*Fac).

reverse_factors(A*B, C*A) :- reverse_factors(B, C), !.
reverse_factors(A, A).
