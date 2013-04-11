-module(levenshtein).
-compile(export_all).

distance_cached(S,T) ->
    {L,_} = ld(S,T,dict:new()),
    L.

distance(S,T) ->
    ld(S,T).

ld([],T) ->
    length(T);
ld(S,[]) ->
    length(S);
ld([X|S],[X|T]) ->
    ld(S,T);
ld([_SH|ST]=S,[_TH|TT]=T) ->
    1 + lists:min([ld(S,TT),ld(ST,T),ld(ST,TT)]).

ld([]=S,T,Cache) ->
    {length(T),dict:store({S,T},length(T),Cache)};
ld(S,[]=T,Cache) ->
    {length(S),dict:store({S,T},length(S),Cache)};
ld([X|S],[X|T],Cache) ->
    ld(S,T,Cache);
ld([_SH|ST]=S,[_TH|TT]=T,Cache) ->
    case dict:is_key({S,T},Cache) of
        true -> {dict:fetch({S,T},Cache),Cache};
        false ->
            {L1,C1} = ld(S,TT,Cache),
            {L2,C2} = ld(ST,T,C1),
            {L3,C3} = ld(ST,TT,C2),
            L = 1+lists:min([L1,L2,L3]),
            {L,dict:store({S,T},L,C3)}
    end.
