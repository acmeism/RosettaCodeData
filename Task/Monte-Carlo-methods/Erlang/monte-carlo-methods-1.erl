-module(monte).
-export([main/1]).

monte(N)->
    monte(N,0,0).

monte(0,InCircle,NumPoints) ->
    4 * InCircle / NumPoints;

monte(N,InCircle,NumPoints)->
    Xcoord = rand:uniform(),
    Ycoord = rand:uniform(),
    monte(N-1,
          if Xcoord*Xcoord + Ycoord*Ycoord < 1 -> InCircle + 1; true -> InCircle end,
          NumPoints + 1).

main(N) -> io:format("PI: ~w~n", [ monte(N) ]).
