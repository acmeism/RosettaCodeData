-module(population_count).
-export([popcount/1]).

-export([task/0]).

popcount(N) ->
    popcount(N,0).

popcount(0,Acc) ->
    Acc;
popcount(N,Acc) ->
    popcount(N div 2, Acc + N rem 2).

threes(_,0,Acc) ->
    lists:reverse(Acc);
threes(Threes,N,Acc) ->
    threes(Threes * 3, N-1, [popcount(Threes)|Acc]).

threes(N) ->
    threes(1,N,[]).

evil(_,0,Acc) ->
    lists:reverse(Acc);
evil(N,Count,Acc) ->
    case popcount(N) rem 2 of
        0 ->
            evil(N+1,Count-1,[N|Acc]);
        1 ->
            evil(N+1,Count,Acc)
    end.
evil(Count) ->
    evil(0,Count,[]).

odious(_,0,Acc) ->
    lists:reverse(Acc);
odious(N,Count,Acc) ->
    case popcount(N) rem 2 of
        1 ->
            odious(N+1,Count-1,[N|Acc]);
        0 ->
            odious(N+1,Count,Acc)
    end.
odious(Count) ->
    odious(1,Count,[]).


task() ->
    io:format("Powers of 3: ~p~n",[threes(30)]),
    io:format("Evil:~p~n",[evil(30)]),
    io:format("Odious:~p~n",[odious(30)]).
