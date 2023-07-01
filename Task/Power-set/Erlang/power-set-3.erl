powerset([]) -> [[]];
powerset([H|T]) -> PT = powerset(T),
  powerset(H, PT, PT).

powerset(_, [], Acc) -> Acc;
powerset(X, [H|T], Acc) -> powerset(X, T, [[X|H]|Acc]).
