%% Arithmetic Geometric Mean of 1 and 1 / sqrt(2)
%% Author: Abhay Jain

-module(agm_calculator).
-export([find_agm/0]).
-define(TOLERANCE, 0.0000000001).

find_agm() ->
    A = 1,
    B = 1 / (math:pow(2, 0.5)),
    AGM = agm(A, B),
    io:format("AGM = ~p", [AGM]).

agm (A, B) when abs(A-B) =< ?TOLERANCE ->
    A;
agm (A, B) ->
    A1 = (A+B) / 2,
    B1 = math:pow(A*B, 0.5),
    agm(A1, B1).
