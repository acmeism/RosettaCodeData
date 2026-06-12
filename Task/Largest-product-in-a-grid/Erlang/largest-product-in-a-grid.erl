module(largest_product_in_a_grid).
-export([main/0]).

%%
%% Main test driver
%%
main() ->
    %% 1. Define the 20×20 grid as a list of lists
    %%    Each inner list is a row.
    %%    Erlang lists are 1-based when using lists:nth.
    Grid = [
        [8,2,22,97,38,15,0,40,0,75,4,5,7,78,52,12,50,77,91,8],
        [49,49,99,40,17,81,18,57,60,87,17,40,98,43,69,48,4,56,62,0],
        [81,49,31,73,55,79,14,29,93,71,40,67,53,88,30,3,49,13,36,65],
        [52,70,95,23,4,60,11,42,69,24,68,56,1,32,56,71,37,2,36,91],
        [22,31,16,71,51,67,63,89,41,92,36,54,22,40,40,28,66,33,13,80],
        [24,47,32,60,99,3,45,2,44,75,33,53,78,36,84,20,35,17,12,50],
        [32,98,81,28,64,23,67,10,26,38,40,67,59,54,70,66,18,38,64,70],
        [67,26,20,68,2,62,12,20,95,63,94,39,63,8,40,91,66,49,94,21],
        [24,55,58,5,66,73,99,26,97,17,78,78,96,83,14,88,34,89,63,72],
        [21,36,23,9,75,0,76,44,20,45,35,14,0,61,33,97,34,31,33,95],
        [78,17,53,28,22,75,31,67,15,94,3,80,4,62,16,14,9,53,56,92],
        [16,39,5,42,96,35,31,47,55,58,88,24,0,17,54,24,36,29,85,57],
        [86,56,0,48,35,71,89,7,5,44,44,37,44,60,21,58,51,54,17,58],
        [19,80,81,68,5,94,47,69,28,73,92,13,86,52,17,77,4,89,55,40],
        [4,52,8,83,97,35,99,16,7,97,57,32,16,26,26,79,33,27,98,66],
        [88,36,68,87,57,62,20,72,3,46,33,67,46,55,12,32,63,93,53,69],
        [4,42,16,73,38,25,39,11,24,94,72,18,8,46,29,32,40,62,76,36],
        [20,69,36,41,72,30,23,88,34,62,99,69,82,67,59,85,74,4,36,16],
        [20,73,35,29,78,31,90,1,74,31,49,71,48,86,81,16,23,57,5,54],
        [1,70,54,71,83,51,54,69,16,92,33,48,61,43,52,1,89,19,67,48]
    ],

    %% 2. Find the largest product info (we ask for groups of length 4)
    Result0 = greatest_product_info(Grid, 4),

    %% 3. The internal routines returned Row/Col as 1-based.
    Product = maps:get(product, Result0),
    Numbers = maps:get(numbers, Result0),
    Row1 = maps:get(row, Result0),
    Col1 = maps:get(col, Result0),
    Direction = maps:get(direction, Result0),

    %% convert to 0-based
    Row0 = Row1 - 1,
    Col0 = Col1 - 1,

    %% print neatly; use format_numbers/1 to show integer list instead of printable string
    io:format("Greatest product of four adjacent numbers (down or right):~n"),
    io:format("  → Product: ~p~n", [Product]),
    io:format("  → Numbers: ~s~n", [format_numbers(Numbers)]),
    io:format("  → Starting position: (row=~p, col=~p)~n", [Row0, Col0]),
    io:format("  → Direction: ~p~n", [Direction]).

%%
%% Sub- and Helper-functions
%%

%% product(List) -> integer
%% Multiply all numbers in a list using fold (reduce).
product(List) ->
    %% lists:foldl(Function, InitialAcc, List)
    %% Function runs left-to-right: fun(X, Acc) -> X * Acc end
    lists:foldl(fun(X, Acc) -> X * Acc end, 1, List).

%% horizontal_groups(Grid, N) -> list of tuples
%%
%% For each row R and column C, take N numbers moving right.
%% Each tuple has the shape:
%%   {NumbersList, RowIndex (1-based), ColIndex (1-based), right}
horizontal_groups(Grid, N) ->
    %% We map over each Row with its 1-based index R
    lists:flatten([
        [ { lists:sublist(Row, C, N), R, C, right }
          || C <- lists:seq(1, length(Row) - N + 1) ]
        || {Row, R} <- lists:zip(Grid, lists:seq(1, length(Grid)))
    ]).

%% vertical_groups(Grid, N) -> list of tuples
%%
%% For each starting row R and each column C, collect N numbers downward:
%%   { [ Grid[R][C], Grid[R+1][C], ..., Grid[R+N-1][C] ], R, C, down }
%%
%% We use helper nth_col(Grid, R, C) to get Grid[R][C].
%% Note: uses 1-based indexing for simplicity with lists:nth/2.
vertical_groups(Grid, N) ->
    Rows = length(Grid),
    Cols = length(hd(Grid)),
    lists:flatten([
        [ { [ nth_col(Grid, R + K, C) || K <- lists:seq(0, N - 1) ],
            R, C, down }
          || C <- lists:seq(1, Cols) ]
        || R <- lists:seq(1, Rows - N + 1)
    ]).

%% nth_col(Grid, R, C) -> integer
%% Helper to get the element at row R and column C.
%% Erlang does not have nested array indexing syntax like Grid[R][C].
%% Instead: get the R-th row with lists:nth/2, then the C-th element of that row.
%% Both lists:nth/2 calls are 1-based.
nth_col(Grid, R, C) ->
    Row = lists:nth(R, Grid),
    lists:nth(C, Row).

%% all_groups(Grid, N) -> list of all groups (horizontal + vertical)
all_groups(Grid, N) ->
    horizontal_groups(Grid, N) ++ vertical_groups(Grid, N).

%% greatest_product_info(Grid, N) -> map
%%
%% For each group (Numbers, R, C, Dir) compute its product, find the maximum,
%% and return a map with detailed info.
%%
%% NOTE: this function returns R and C as 1-based (we convert to 0-based in main/0).
greatest_product_info(Grid, N) ->
    Groups = all_groups(Grid, N),

    %% Build list of {ProductValue, GroupTuple} so we can find the max easily
    Pairs = [ { product(element(1, G)), G } || G <- Groups ],

    %% lists:max/1 finds the tuple with the largest first element (ProductValue).
    { _, { Numbers, Row, Col, Direction } } = lists:max(Pairs),

    %% Return details in a map for clarity
    #{
        product => product(Numbers),
        numbers => Numbers,
        row => Row,
        col => Col,
        direction => Direction
    }.



%% format_numbers(Numbers) -> String (list)
%%
%% Convert a list of integers into the textual representation
%% so Erlang will print it as the integer-list string instead
%% of the printable-character string.
%%
format_numbers(Numbers) ->
    %% Convert each integer to a string (list of characters)
    StrItems = [ integer_to_list(N) || N <- Numbers ],
    %% Join with ", "
    Joined = join(StrItems, ", "),
    %% Surround with brackets and return
    lists:concat(["[", Joined, "]"]).

%% join(ListOfStrings, Sep) -> String
%%
%% Helper to join a list of strings with a separator.
%% This is a simple recursive join implementation.
%% Example: join(["1","2","3"], ", ") -> "1, 2, 3"
join([], _Sep) -> "";
join([H], _Sep) -> H;
join([H|T], Sep) -> lists:concat([H, Sep, join(T, Sep)]).

