%%% ============================================================
%%%  Stem-and-Leaf Plot in Erlang
%%% ============================================================
%%%  - Pure functions
%%%  - No mutation
%%%  - Deterministic transformations
%%%  - Explicit functional pipeline
%%% ============================================================

-module(stem_leaf).
-export([main/0]).

%%% ============================================================
%%% 1. Mathematical Helpers (Pure Functions)
%%% ============================================================

%% expand_number/1
%% Conceptually expands single digit numbers to two-digit
%% (e.g., 7 -> 07). Numerically unchanged, but included
%% for semantic clarity.
expand_number(N) ->
    N.

%% stem/1
%% Returns the stem (all but the last digit).
%% Example: 127 -> 12
stem(N) ->
    N div 10.

%% leaf/1
%% Returns the leaf (last digit).
%% Example: 127 -> 7
leaf(N) ->
    N rem 10.

%% range/2
%% Returns a list of integers from From to To (inclusive).
%% Used to guarantee stems 0..14 are always present.
range(From, To) when From =< To ->
    lists:seq(From, To).

%%% ============================================================
%%% 2. Data Transformation Pipeline
%%% ============================================================

%% build_stem_leaf/1
%% Takes raw data and returns a list of:
%%     [{Stem, [SortedLeaves]}, ...]
%%
%% Steps:
%% 1. Expand numbers
%% 2. Sort entire dataset
%% 3. Generate all stems 0..14
%% 4. Collect and sort leaves for each stem
build_stem_leaf(Data) ->
    Expanded = [expand_number(N) || N <- Data],
    Sorted = lists:sort(Expanded),
    Stems = range(0, 14),
    [{S, sorted_leaves(S, Sorted)} || S <- Stems].

%% sorted_leaves/2
%% Filters all numbers matching a given stem
%% Extracts leaves
%% Sorts leaves
sorted_leaves(StemValue, Data) ->
    Leaves =
        [leaf(N) || N <- Data, stem(N) =:= StemValue],
    lists:sort(Leaves).

%%% ============================================================
%%% 3. Formatting Functions (Pure Rendering Layer)
%%% ============================================================

%% format_stem/1
%% Formats stem as two digits (leading zero if needed).
%% Example: 7 -> "07"
format_stem(S) ->
    io_lib:format("~2..0B", [S]).

%% format_leaves/1
%% Converts list of integers into space-separated string.
%% Example: [1,3,7] -> "1 3 7"
format_leaves([]) ->
    "";
format_leaves(Leaves) ->
    string:join([integer_to_list(L) || L <- Leaves], " ").

%% render_line/1
%% Converts {Stem, Leaves} into formatted line.
%% Example:
%%   {12, [3,4,7]} -> "12 | 3 4 7"
render_line({StemValue, Leaves}) ->
    lists:flatten(
        io_lib:format("~s | ~s",
            [format_stem(StemValue), format_leaves(Leaves)])
    ).

%% render_plot/1
%% Converts full stem-leaf structure into multi-line string.
render_plot(StemLeafPairs) ->
    Lines = [render_line(Pair) || Pair <- StemLeafPairs],
    string:join(Lines, "\n").

%%% ============================================================
%%% 4. Program Entry Point
%%% ============================================================

main() ->
    %% --------------------------------------------------------
    %% Raw Dataset
    %% --------------------------------------------------------
    Data = [
        12,127,28,42,39,113,42,18,44,118,44,37,113,124,37,48,127,36,29,31,
        125,139,131,115,105,132,104,123,35,113,122,42,117,119,58,109,23,
        105,63,27,44,105,99,41,128,121,116,125,32,61,37,127,29,113,121,
        58,114,126,53,114,96,25,109,7,31,141,46,13,27,43,117,116,27,7,
        68,40,31,115,124,42,128,52,71,118,117,38,27,106,33,117,116,111,
        40,119,47,105,57,122,109,124,115,43,120,43,27,27,18,28,48,125,
        107,114,34,133,45,120,30,127,31,116,146
    ],

    %% --------------------------------------------------------
    %% Functional Processing Pipeline
    %% --------------------------------------------------------
    StemLeafStructure = build_stem_leaf(Data),
    Plot = render_plot(StemLeafStructure),

    %% --------------------------------------------------------
    %% Output
    %% --------------------------------------------------------
    io:format("~s~n", [Plot]).
