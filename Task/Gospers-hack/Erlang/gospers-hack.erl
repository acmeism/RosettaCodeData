-module(gospers_hack).
-export([main/0]).
%% ----------------------------------------------------------------------------
%% Function: gospers_hack/1
%% Purpose: Given a positive integer X, returns the next higher number
%%          with the same number of set bits (1s) using Gosper's Hack.
%% ----------------------------------------------------------------------------
gospers_hack(X) ->
    C = X band (-X),                    %% Step 1: Isolate lowest set bit
    R = X + C,                          %% Step 2: Add to get ripple carry
    NewBits = ((X bxor R) bsr 2) div C, %% Step 3 & 4: Shift & divide changed bits
    R bor NewBits.                      %% Step 5: Combine with ripple to form result
%% ----------------------------------------------------------------------------
%% Function: generate_sequence/2
%% Purpose: Generate a list of N values using Gosper’s Hack starting from X.
%% ----------------------------------------------------------------------------
generate_sequence(X, N) ->
    generate_sequence(X, N, []).
generate_sequence(_, 0, Acc) ->
    lists:reverse(Acc);  %% Stop when N reaches 0
generate_sequence(X, N, Acc) ->
    Next = gospers_hack(X),
    generate_sequence(Next, N - 1, [Next | Acc]).
%% ----------------------------------------------------------------------------
%% Function: format_result/2
%% Purpose: Format the sequence nicely into a string like:
%%          " 3:  5, 6, 9, 10, ..."
%% ----------------------------------------------------------------------------
format_result(Start, Sequence) ->
    ValuesStr = lists:map(fun(N) -> integer_to_list(N) end, Sequence),
    Joined = string:join(ValuesStr, ", "),
    io:format("~2w:  ~s,~n", [Start, Joined]).
%% ----------------------------------------------------------------------------
%% Function: main/0
%% Purpose: Entry point – prints 10 results for each of 1, 3, 7, and 15.
%% ----------------------------------------------------------------------------
main() ->
    Starts = [1, 3, 7, 15],
    lists:foreach(
      fun(Start) ->
          Sequence = generate_sequence(Start, 10),
          format_result(Start, Sequence)
      end,
      Starts).
