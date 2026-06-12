-module(cyk_parser).
-export([cyk_parse/2]).

-define(START, "NP").

%% CYK parser implementation. Returns true if W is valid CYK under R rules.
cyk_parse(W, R) ->
    N = length(W),
    T = initialize_table(N),
    T1 = fill_table(W, R, N, T),
    sets:is_element(?START, get_cell(T1, 1, N)).

%% Initialize the parsing table with empty sets
initialize_table(N) ->
    maps:from_list([{{I, J}, sets:new()} || I <- lists:seq(1, N),
                                             J <- lists:seq(1, N)]).

%% Fill the parsing table using CYK algorithm
fill_table(W, R, N, T) ->
    fill_columns(W, R, N, 1, T).

fill_columns(_W, _R, N, J, T) when J > N ->
    T;
fill_columns(W, R, N, J, T) ->
    %% Fill terminal productions
    Word = lists:nth(J, W),
    T1 = add_terminals(R, Word, J, T),

    %% Fill non-terminal productions
    T2 = fill_backward(R, J, J, T1),

    fill_columns(W, R, N, J + 1, T2).

%% Add terminal productions to table
add_terminals(R, Word, J, T) ->
    maps:fold(
        fun(LHS, Rules, Acc) ->
            case has_terminal_rule(Rules, Word) of
                true -> add_to_cell(Acc, J, J, LHS);
                false -> Acc
            end
        end,
        T,
        R
    ).

%% Check if rules contain a terminal production for Word
has_terminal_rule(Rules, Word) ->
    lists:any(
        fun(Rule) ->
            length(Rule) =:= 1 andalso hd(Rule) =:= Word
        end,
        Rules
    ).

%% Fill backward diagonally from position J
fill_backward(_R, I, _J, T) when I < 1 ->
    T;
fill_backward(R, I, J, T) ->
    T1 = fill_splits(R, I, J, I, J - 1, T),
    fill_backward(R, I - 1, J, T1).

%% Try all split points K from I to J-1
fill_splits(_R, _I, _J, K, MaxK, T) when K > MaxK ->
    T;
fill_splits(R, I, J, K, MaxK, T) ->
    T1 = check_all_rules(R, I, J, K, T),
    fill_splits(R, I, J, K + 1, MaxK, T1).

%% Check all grammar rules for a split point
check_all_rules(R, I, J, K, T) ->
    maps:fold(
        fun(LHS, Rules, Acc) ->
            check_rules(LHS, Rules, I, J, K, Acc)
        end,
        T,
        R
    ).

%% Check individual rules
check_rules(_LHS, [], _I, _J, _K, T) ->
    T;
check_rules(LHS, [Rule | Rest], I, J, K, T) ->
    T1 = case length(Rule) =:= 2 of
        true ->
            [RHS1, RHS2] = Rule,
            LeftCell = get_cell(T, I, K),
            RightCell = get_cell(T, K + 1, J),
            case sets:is_element(RHS1, LeftCell) andalso
                 sets:is_element(RHS2, RightCell) of
                true -> add_to_cell(T, I, J, LHS);
                false -> T
            end;
        false ->
            T
    end,
    check_rules(LHS, Rest, I, J, K, T1).

%% Helper functions for table manipulation
get_cell(T, I, J) ->
    maps:get({I, J}, T, sets:new()).

add_to_cell(T, I, J, Element) ->
    Cell = get_cell(T, I, J),
    NewCell = sets:add_element(Element, Cell),
    maps:put({I, J}, NewCell, T).

%% Test the CYK parser with a sample grammar and input string
main(_) ->
    R = #{
        "NP" => [["Det", "Nom"]],
        "Nom" => [
            ["AP", "Nom"],
            ["book"],
            ["orange"],
            ["man"]
        ],
        "AP" => [
            ["Adv", "A"],
            ["heavy"],
            ["orange"],
            ["tall"]
        ],
        "Det" => [["a"]],
        "Adv" => [["very"], ["extremely"]],
        "A" => [
            ["heavy"],
            ["orange"],
            ["tall"],
            ["muscular"]
        ]
    },
    W = string:split("a very heavy orange book", " ", all),
    Result = cyk_parse(W, R),
    io:format("CYK Parse Result: ~p~n", [Result]),
    Result.
