module(lcs).
-compile(export_all).

lcs_length(S,T) ->
    {L,_C} = lcs_length(S,T,dict:new()),
    L.

lcs_length([]=S,T,Cache) ->
    {0,dict:store({S,T},0,Cache)};
lcs_length(S,[]=T,Cache) ->
    {0,dict:store({S,T},0,Cache)};
lcs_length([H|ST]=S,[H|TT]=T,Cache) ->
    {L,C} = lcs_length(ST,TT,Cache),
    {L+1,dict:store({S,T},L+1,C)};
lcs_length([_SH|ST]=S,[_TH|TT]=T,Cache) ->
    case dict:is_key({S,T},Cache) of
        true -> {dict:fetch({S,T},Cache),Cache};
        false ->
            {L1,C1} = lcs_length(S,TT,Cache),
            {L2,C2} = lcs_length(ST,T,C1),
            L = lists:max([L1,L2]),
            {L,dict:store({S,T},L,C2)}
    end.

lcs(S,T) ->
    {_,C} = lcs_length(S,T,dict:new()),
    lcs(S,T,C,[]).

lcs([],_,_,Acc) ->
    lists:reverse(Acc);
lcs(_,[],_,Acc) ->
    lists:reverse(Acc);
lcs([H|ST],[H|TT],Cache,Acc) ->
    lcs(ST,TT,Cache,[H|Acc]);
lcs([_SH|ST]=S,[_TH|TT]=T,Cache,Acc) ->
    case dict:fetch({S,TT},Cache) > dict:fetch({ST,T},Cache) of
        true ->
            lcs(S,TT,Cache, Acc);
        false ->
            lcs(ST,T,Cache,Acc)
    end.
