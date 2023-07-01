-module(ca).
-compile(export_all).

run(N,G) ->
    run(N,G,0).

run(GN,G,GN) ->
    io:fwrite("~B: ",[GN]),
    print(G);
run(N,G,GN) ->
    io:fwrite("~B: ",[GN]),
    print(G),
    run(N,next(G),GN+1).

print([]) ->
    io:fwrite("~n");
print([0|T]) ->
    io:fwrite("_"),
    print(T);
print([1|T]) ->
    io:fwrite("#"),
    print(T).

next([]) ->
    [];
next([_]) ->
    [0];
next([H,1|_]=G) ->
    next(G,[H]);
next([_|_]=G) ->
    next(G,[0]).

next([],Acc) ->
    lists:reverse(Acc);
next([0,_],Acc) ->
    next([],[0|Acc]);
next([1,X],Acc) ->
    next([],[X|Acc]);
next([0,X,0|T],Acc) ->
    next([X,0|T],[0|Acc]);
next([1,X,0|T],Acc) ->
    next([X,0|T],[X|Acc]);
next([0,X,1|T],Acc) ->
    next([X,1|T],[X|Acc]);
next([1,0,1|T],Acc) ->
    next([0,1|T],[1|Acc]);
next([1,1,1|T],Acc) ->
    next([1,1|T],[0|Acc]).
