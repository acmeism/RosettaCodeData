pow(X, Y) when Y < 0 ->
    1/pow(X, -Y);
pow(X, Y) when is_integer(Y) ->
    pow(X, Y, 1).

pow(_, 0, B) ->
    B;
pow(X, Y, B) ->
    B2 = if Y rem 2 =:= 0 -> B; true -> X * B end,
    pow(X * X, Y div 2, B2).
