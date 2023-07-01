-module(monte2).
-export([main/1]).

monte(N)->
    monte(N,0,0).

monte(0,InCircle,NumPoints) ->
    4 * InCircle / NumPoints;

monte(N,InCircle,NumPoints)->
    X = rand:uniform(),
    Y = rand:uniform(),
    monte(N-1, within(X,Y,InCircle), NumPoints + 1).

within(X,Y,IN)->
          if X*X + Y*Y < 1 -> IN + 1;
          true -> IN
          end.

main(N) -> io:format("PI: ~w~n", [ monte(N) ]).
