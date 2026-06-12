-module(find_square_difference).
-export([main/0, find_smallest_n/1, square/1, square_difference/1,
         difference_greater_than_limit/2]).

%%%-------------------------------------------------------------------
%%% Calculates the square of a number.
%%%-------------------------------------------------------------------
square(Number) ->
    Number * Number.

%%%-------------------------------------------------------------------
%%% Calculates the difference:  N^2 - (N-1)^2
%%%-------------------------------------------------------------------
square_difference(N) ->
    square(N) - square(N - 1).

%%%-------------------------------------------------------------------
%%% Checks if the square difference is greater than a limit.
%%%-------------------------------------------------------------------
difference_greater_than_limit(N, Limit) ->
    square_difference(N) > Limit.

%%%-------------------------------------------------------------------
%%% Finds the smallest positive integer N where: N^2 - (N-1)^2 > Limit
%%% The search starts at N = 1.
%%%-------------------------------------------------------------------
find_smallest_n(Limit) ->
    find_smallest_n(Limit, 1).

%%%-------------------------------------------------------------------
%%% Tail-recursive helper function
%%%
%%% Parameters:
%%%   Limit - threshold
%%%   N     - current candidate
%%%-------------------------------------------------------------------
find_smallest_n(Limit, N) ->
    case difference_greater_than_limit(N, Limit) of
        true ->
            N;  % Condition satisfied, return result
        false ->
            find_smallest_n(Limit, N + 1) % Try next number
    end.

%%%-------------------------------------------------------------------
%%% Main function
%%%-------------------------------------------------------------------
main() ->
    Limit = 1000,
    N = find_smallest_n(Limit),
    Difference = square_difference(N),

    io:format("Limit: ~p~n", [Limit]),
    io:format("Smallest N: ~p~n", [N]),
    io:format("Square difference: ~p~n", [Difference]).

