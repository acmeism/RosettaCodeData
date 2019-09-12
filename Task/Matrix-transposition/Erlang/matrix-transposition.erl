-module(transmatrix).
-export([trans/1,transL/1]).

% using built-ins hd = head, tl = tail

trans([[]|_]) -> [];
trans(M) ->
  [ lists:map(fun hd/1, M) | transpose( lists:map(fun tl/1, M) ) ].

% Purist version

transL( [ [Elem | Rest] | List] ) ->
    [ [Elem | [H || [H | _] <- List] ] |
      transL( [Rest |
                      [ T || [_ | T] <- List ] ]
       ) ];
transL([ [] | List] ) -> transL(List);
transL([]) -> [].
