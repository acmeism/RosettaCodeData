insert(X, L, [X|L]).
insert(X, [Y|Ys], [Y|L2]) :- insert(X, Ys, L2).

permutation([], []).
permutation([X|Xs], P) :- permutation(Xs, L), insert(X, L, P).
