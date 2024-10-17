-module(cheryl).
-export([main/0]).

main() ->
    Dates = [{may,15}, {may,16}, {may,19},
             {june,17}, {june,18},
             {july,14}, {july,16},
             {august,14}, {august,15}, {august,17}],
    ByM = lists:foldl(fun({M,D},L) -> orddict:append(M,D,L) end, [], Dates),
    ByD = lists:foldl(fun({M,D},L) -> orddict:append(D,M,L) end, [], Dates),
    Eliminated = lists:uniq([M || {_, [M]} <- ByD]),
    Remaining = [{M,D} || {M,D} <- ByM,
                          not lists:member(M, Eliminated)],
    [{M,D} || {M, Ds} <- Remaining,
              {_, OtherDs} <- Remaining -- [{M,Ds}],
              [D] <- [Ds --  OtherDs]].
