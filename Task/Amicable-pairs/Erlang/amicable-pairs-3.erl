friendly(Limit) ->
    List = [{X,properdivs:sumdivs(X)} || X <- lists:seq(3,Limit)],
    Final = [ X || X <- lists:seq(3,Limit), X == properdivs:sumdivs(proplists:get_value(X,List))
            andalso X =/= proplists:get_value(X,List)],
    findfriendlies(Final,[]).


findfriendlies(List,Acc) when length(List) =< 0 -> Acc;
findfriendlies(List,Acc) ->
    A = lists:nth(1,List),
    AS = sumdivs(A),
    B = lists:nth(2,List),
    BS = sumdivs(B),
    if
        AS == B andalso BS == A ->
          {_,BL} = lists:split(2,List),
          findfriendlies(BL,Acc++[{A,B}]);
        true -> false
    end.
