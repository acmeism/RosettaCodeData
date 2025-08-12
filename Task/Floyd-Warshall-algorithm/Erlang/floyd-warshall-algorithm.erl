-module(floyd_warshall).
-export([main/2]).


main(N, Edge) ->
    {Dist, Next} = setup(N, Edge),
    {Dist2, Next2} = shortest_path(N, Dist, Next),
    print(N, Dist2, Next2).

setup(N, Edge) ->
    Big = 1.0e300,
    Dist = maps:from_list([{{I,J}, case I == J of true -> 0; false -> Big end}
                          || I <- lists:seq(1, N), J <- lists:seq(1, N)]),
    Next = maps:from_list([{{I,J}, nil}
                          || I <- lists:seq(1, N), J <- lists:seq(1, N)]),
    lists:foldl(fun({U, V, W}, {Dst, Nxt}) ->
                    {maps:put({U, V}, W, Dst), maps:put({U, V}, V, Nxt)}
                end, {Dist, Next}, Edge).

shortest_path(N, Dist, Next) ->
    Combinations = [{K, I, J} || K <- lists:seq(1, N),
                                 I <- lists:seq(1, N),
                                 J <- lists:seq(1, N)],
    lists:foldl(fun({K, I, J}, {Dst, Nxt}) ->
                    IJ_Dist = maps:get({I, J}, Dst),
                    IK_Dist = maps:get({I, K}, Dst),
                    KJ_Dist = maps:get({K, J}, Dst),
                    case IJ_Dist > IK_Dist + KJ_Dist of
                        true ->
                            NewDist = maps:put({I, J}, IK_Dist + KJ_Dist, Dst),
                            NewNext = maps:put({I, J}, maps:get({I, K}, Nxt), Nxt),
                            {NewDist, NewNext};
                        false ->
                            {Dst, Nxt}
                    end
                end, {Dist, Next}, Combinations).

print(N, Dist, Next) ->
    io:format("pair     dist    path~n"),
    [io:format("~w -> ~w  ~4w     ~s~n", [I, J, maps:get({I, J}, Dist), path(Next, I, J)])
     || I <- lists:seq(1, N), J <- lists:seq(1, N), I =/= J].

path(Next, I, J) ->
    PathList = path(Next, I, J, [I]),
    string:join([integer_to_list(X) || X <- PathList], " -> ").

path(_Next, I, I, List) ->
    lists:reverse(List);
path(Next, I, J, List) ->
    U = maps:get({I, J}, Next),
    path(Next, U, J, [U | List]).

% Usage example:
main(_) -> main(4, [{1, 3, -2}, {2, 1, 4}, {2, 3, 3}, {3, 4, 2}, {4, 2, -1}]).
