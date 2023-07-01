-module(longest_increasing_subsequence).

-export([test_naive/0, test_memo/0, test_patience/0, test_patience2/0, test_compare/1]).

% **************************************************
% Interface to test the implementation
% **************************************************

test_compare(N) when N =< 20 ->
    Funs = [
        {"Naive", fun lis/1},
        {"Memo", fun memo/1},
        {"Patience", fun patience_lis/1},
        {"Patience2", fun patience2/1}
    ],
    do_compare(Funs, N);
test_compare(N) when N =< 500 ->
    Funs = [
        {"Memo", fun memo/1},
        {"Patience", fun patience_lis/1},
        {"Patience2", fun patience2/1}
    ],
    do_compare(Funs, N);
test_compare(N) ->
    Funs = [
        {"Patience", fun patience_lis/1},
        {"Patience2", fun patience2/1}
    ],
    do_compare(Funs, N).

do_compare(Funs, N) ->
    List = [rand:uniform(1000) || _ <- lists:seq(1,N)],
    Results = [{Name, timer:tc(fun() -> F(List) end)} || {Name,F} <- Funs],
    Times = [{Name, Time} || {Name, {Time, _Result}} <- Results],
    io:format("Result Times: ~p~n", [Times]).

test_naive() ->
    test_gen(fun lis/1).

test_memo() ->
    test_gen(fun memo/1).

test_patience() ->
    test_gen(fun patience_lis/1).

test_patience2() ->
    test_gen(fun patience2/1).

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
% Copied from http://stackoverflow.com/a/4762387/4162959
% **************************************************

maxBy(F, L) ->
    element(
        2,
        lists:max([ {F(X), X} || X <- L])
    ).

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

% **************************************************
% Memoization implementation, Roman Rabinovich
% **************************************************
memo(S) ->
    put(test, #{}),
    memo(S, -1).

memo([], _) -> [];
memo([H | Tail] = S, Min) when H > Min ->
    case maps:get({S,Min}, get(test), undefined) of
        undefined ->
            L1 = [H | memo(Tail, H)],
            L2 = memo(Tail, Min),
            case length(L1) >= length(L2) of
                true ->
                    Map = get(test),
                    put(test, Map#{{S, Min} => L1}),
                    L1;
                _ ->
                    Map = get(test),
                    put(test, Map#{{S, Min} => L2}),
                    L2
            end;
        X -> X
    end;
memo([_|Tail], Min) ->
    memo(Tail, Min).

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
% Patience2 by Roman Rabinovich, improved performance over above
% **************************************************
patience2([]) -> [];
patience2([H|L]) ->
    Piles = [[{H, undefined}]],
    patience2(L, Piles, []).

patience2([], Piles, _) ->
    get_seq(lists:reverse(Piles));

patience2([H|T], [[{PE,_}|_Rest] = Pile| Piles], PrevPiles) when H =< PE ->
    case PrevPiles of
        [] -> patience2(T, [[{H, undefined}|Pile]|Piles], []);
        [[{K,_}|_]|_] -> patience2(T, lists:reverse(PrevPiles) ++ [[{H, K}|Pile]|Piles], [])
    end;

patience2([H|_T] = L, [[{PE,_}|_Rest] = Pile| Piles], PrevPiles) when H > PE ->
    patience2(L, Piles, [Pile|PrevPiles]);

patience2([H|T], [], [[{K,_}|_]|_]=PrevPiles) ->
    patience2(T, lists:reverse([[{H,K}]|PrevPiles]), []).

get_seq([]) -> [];
get_seq([[{K,P}|_]|Rest]) ->
    get_seq(P, Rest, [K]).

get_seq(undefined, [], Seq) -> Seq;
get_seq(K, [Pile|Rest], Seq) ->
    case lists:keyfind(K, 1, Pile) of
        undefined -> get_seq(K, Rest, Seq);
        {K, P} -> get_seq(P, Rest, [K|Seq])
    end.

% **************************************************
