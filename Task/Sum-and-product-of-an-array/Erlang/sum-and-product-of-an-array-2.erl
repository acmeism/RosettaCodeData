{Prod,Sum} = lists:foldl(fun (X, {P,S}) -> {P*X,S+X} end, {1,0}, lists:seq(1,10)).
