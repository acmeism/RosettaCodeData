-module(walsh_matrix).
-export([main/0]).

%%% ---------------------------------------------------------------------
%%% Entry point
main() ->
    %% Generate and print Walsh matrices for k = 0 to 3
    lists:foreach(fun(K) -> print_walsh_matrix(K) end, lists:seq(0, 3)).

%%% ---------------------------------------------------------------------
%%% Generate the naturally ordered Walsh matrix of order 2^K
walsh(0) ->
    [[1]];  %% Base case: 1x1 matrix
walsh(K) when K > 0 ->
    Smaller = walsh(K - 1),
    combine(Smaller).

%%% ---------------------------------------------------------------------
%%% Combine smaller matrix to form a larger one as per recursive rule:
%%%
%%%     H_{2n} = [ H_n  H_n
%%%                H_n -H_n ]
combine(M) ->
    %% Top part: each row concatenated with itself
    Top = [Row ++ Row || Row <- M],

    %% Bottom part: each row concatenated with its negation
    Bottom = [Row ++ [ -X || X <- Row ] || Row <- M],

    %% Return combined matrix
    Top ++ Bottom.

%%% ---------------------------------------------------------------------
%%% Format a number into a fixed-width (3-character) string
format_cell(N) when N >= 0 ->
    io_lib:format(" ~2w", [N]);   %% Pad positive numbers with space
format_cell(N) ->
    io_lib:format("~3w", [N]).    %% Already has '-' sign, pad to 3 width

%%% ---------------------------------------------------------------------
%%% Print the matrix as a perfect rectangle with padded cells
print_matrix(Matrix) ->
    lists:foreach(
      fun(Row) ->
          Cells = [ lists:flatten(format_cell(N)) || N <- Row ],
          io:format("~s~n", [string:join(Cells, " ")])
      end,
      Matrix).

%%% ---------------------------------------------------------------------
%%% Print Walsh matrix for a specific k with header
print_walsh_matrix(K) ->
    Size = trunc(math:pow(2, K)),
    Matrix = walsh(K),
    io:format("~nWalsh matrix of order 2^~p (~p x ~p):~n", [K, Size, Size]),
    print_matrix(Matrix).
