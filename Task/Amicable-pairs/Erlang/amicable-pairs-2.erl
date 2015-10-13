friendly(Limit) ->
    List = [{X,properdivs:sumdivs(X)} || X <- lists:seq(3,Limit)],
    Final = [ X ||
        X <- lists:seq(3,Limit),
        X == properdivs:sumdivs(proplists:get_value(X,List))
        andalso X =/= proplists:get_value(X,List)],
    io:format("L: ~w~n", [Final]).
