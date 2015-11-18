-module(longest_increasing_subsequence).

-export([test_naive/0, test_patience/0]).

% **************************************************
% Interface to test the implementation
% **************************************************

test_naive() ->
    test_gen(fun lis/1).

test_patience() ->
    test_gen(fun patience_lis/1).

test_gen(F) ->
    show_result(F([3,2,6,4,5,1])),
    show_result(F([0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15])).

show_result(Res) ->
    io:format("~w\n", [Res]).

% **************************************************

% **************************************************
% Naive implementation
% **************************************************

lis(L) ->
    maxBy(
        fun(SS) -> length(SS) end,
        [ lists:usort(SS)
            ||  SS <- combos(L),
                SS == lists:sort(SS)]
    ).

% **************************************************

% **************************************************
% Patience sort implementation
% **************************************************

patience_lis(L) ->
    patience_lis(L, []).

patience_lis([H | T], Stacks) ->
    NStacks =
        case Stacks of
            [] ->
                [[{H,[]}]];
            _ ->
                place_in_stack(H, Stacks, [])
        end,
    patience_lis(T, NStacks);
patience_lis([], Stacks) ->
    case Stacks of
        [] ->
            [];
        [_|_] ->
            lists:reverse( recover_lis( get_previous(Stacks) ) )
    end.

place_in_stack(E, [Stack = [{H,_} | _] | TStacks], PrevStacks) when H > E ->
    PrevStacks ++ [[{E, get_previous(PrevStacks)} | Stack] | TStacks];
place_in_stack(E, [Stack = [{H,_} | _] | TStacks], PrevStacks) when H =< E ->
    place_in_stack(E, TStacks, PrevStacks ++ [Stack]);
place_in_stack(E, [], PrevStacks)->
    PrevStacks ++ [[{E, get_previous(PrevStacks)}]].

get_previous(Stack = [_|_]) ->
    hd(lists:last(Stack));
get_previous([]) ->
    [].

recover_lis({E,Prev}) ->
    [E|recover_lis(Prev)];
recover_lis([]) ->
    [].

% **************************************************

% **************************************************
% Copied from http://stackoverflow.com/a/4762387/4162959
% **************************************************

maxBy(F, L) ->
    element(
        2,
        lists:max([ {F(X), X} || X <- L])
    ).

% **************************************************

% **************************************************
% Copied from https://panduwana.wordpress.com/2010/04/21/combination-in-erlang/
% **************************************************

combos(L) ->
    lists:foldl(
        fun(K, Acc) -> Acc++(combos(K, L)) end,
        [[]],
        lists:seq(1, length(L))
    ).

combos(1, L) ->
    [[X] || X <- L];
combos(K, L) when K == length(L) ->
    [L];
combos(K, [H|T]) ->
    [[H | Subcombos]
        || Subcombos <- combos(K-1, T)]
    ++ (combos(K, T)).

% **************************************************
