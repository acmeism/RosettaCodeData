-module(common_sorted).
-export([common_sorted_list/1, main/0]).

%% ----------------------------------------------------------
%% main() -> acts like a test driver
%% ----------------------------------------------------------
main() ->
    Input = [[5,1,3,8,9,4,8,7],
             [3,5,9,8,4],
             [1,3,7,9]],
    Result = common_sorted_list(Input),
    io:format("Input: ~p~nResult: ~p~n", [Input, Result]).

%% ----------------------------------------------------------
%% common_sorted_list(Lists) -> Sorted list of unique elements
%% ----------------------------------------------------------
common_sorted_list(Lists) ->
    %% Step 1: Convert each list into a set (remove duplicates)
    Sets = lists:map(fun lists:usort/1, Lists),

    %% Step 2: Reduce with union across all sets
    Union = lists:foldl(fun union/2, [], Sets),

    %% Step 3: Sort and ensure unique
    lists:usort(Union).

%% ----------------------------------------------------------
%% Helper: union(ListA, ListB)
%% Returns unique elements from both lists
%% ----------------------------------------------------------
union(A, B) ->
    lists:usort(A ++ B).
