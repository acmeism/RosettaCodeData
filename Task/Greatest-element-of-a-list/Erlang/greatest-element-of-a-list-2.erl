list_max([H|T]) -> lists:foldl(fun erlang:max/2, H, T).
