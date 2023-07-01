% create the list:
L = lists:seq(1, 10).

% and compute its sum:
S = lists:sum(L).
P = lists:foldl(fun (X, P) -> X * P end, 1, L).
