-module(harshad).
-export([main/0,harshad/1,seq/1]).

% We return the number R if harshad, else 0
harshad(R) ->
        case R
        rem lists:sum([X - $0|| X <- erlang:integer_to_list(R)]) of 0
        -> R; _ -> 0 end.

% build a list of harshads retrieving input from harshad(R)
% filter out the nulls and return
hlist(A,B) ->
      RL =  [ harshad(X) || X <- lists:seq(A,B) ],
      lists:filter( fun(X) -> X > 0 end,  RL).

seq(Total) -> seq(Total, [], 0).

seq(Total,L,_) when length(L) == Total-> L;
seq(Total,L,Acc) when length(L) < Total ->
      NL = hlist(1,Total + Acc),
      seq(Total,NL,Acc+1).

gt(_,L) when length(L) == 1 ->  hd(L);
gt(X,_) ->
      NL = hlist(X+1,X+2),
      gt(X+2,NL).

main() ->
      io:format("seq(20): ~w~n", [ seq(20) ]),
      io:format("gt(1000): ~w~n", [ gt(1000,[]) ]).
