powerset([]) -> [[]];
powerset([H|T]) -> PT = powerset(T),
  [ [H|X] || X <- PT ] ++ PT.
