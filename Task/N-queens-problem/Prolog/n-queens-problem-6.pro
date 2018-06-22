not_diagonal(X, N) :-
  maplist(plus, X, N, Z1), maplist(plus, X, Z2, N), is_set(Z1), is_set(Z2).

queens(N, Qs) :-
  numlist(1, N, P), findall(Q, (permutation(P, Q), not_diagonal(Q, P)), Qs).
