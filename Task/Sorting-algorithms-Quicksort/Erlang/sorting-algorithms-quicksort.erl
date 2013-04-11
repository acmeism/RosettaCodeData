qsort([]) -> [];
qsort([X|Xs]) ->
   qsort([ Y || Y <- Xs, Y < X]) ++ [X] ++ qsort([ Y || Y <- Xs, Y >= X]).
