-module(median).
-import(lists, [nth/2, sort/1]).
-compile(export_all).


test(MaxInt,ListSize,TimesToRun) ->
    test(MaxInt,ListSize,TimesToRun,[[],[]]).

test(_,_,0,[GMAcc, OMAcc]) ->
    Len = length(GMAcc),
    {GMT,GMV} = lists:foldl(fun({T, V}, {AT,AV}) -> {AT + T, AV + V} end, {0,0}, GMAcc),
    {OMT,OMV} = lists:foldl(fun({T, V}, {AT,AV}) -> {AT + T, AV + V} end, {0,0}, OMAcc),
    io:format("QuickSelect Time: ~p, Val: ~p~nOriginal Time: ~p, Val: ~p~n", [GMT/Len, GMV/Len, OMT/Len, OMV/Len]);
test(M,N,T,[GMAcc, OMAcc]) ->
    L = [rand:uniform(M) || _ <- lists:seq(1,N)],
    GM = timer:tc(fun() -> qs_median(L) end),
    OM = timer:tc(fun() -> median(L) end),
    test(M,N,T-1,[[GM|GMAcc], [OM|OMAcc]]).

median(Unsorted) ->
    Sorted = sort(Unsorted),
    Length = length(Sorted),
    Mid = Length div 2,
    Rem = Length rem 2,
    (nth(Mid+Rem, Sorted) + nth(Mid+1, Sorted)) / 2.

% ***********************************************************
% median based on quick select with optimizations for repeating numbers
% if it really matters it's a little faster
% by Roman Rabinovich
% ***********************************************************

qs_median([]) -> error;
qs_median([X]) -> X;
qs_median([P|_Tail] = List) ->
    TargetPos = length(List)/2 + 0.5,
    qs_median(List, TargetPos, P, 0).

qs_median([X], 1, _, 0) ->  X;
qs_median([X], 1, _, Acc) ->  (X + Acc)/2;
qs_median([P|Tail], TargetPos, LastP, Acc) ->
    Smaller = [X || X <- Tail, X < P],
    LS = length(Smaller),
    qs_continue(P, LS, TargetPos, LastP, Smaller, Tail, Acc).

qs_continue(P, LS, TargetPos, _, _, _, 0) when LS + 1 == TargetPos -> P;
qs_continue(P, LS, TargetPos, _, _, _, Acc) when LS + 1 == TargetPos -> (P + Acc)/2;
qs_continue(P, 0, TargetPos, LastP, _SM, _TL, _Acc) when TargetPos == 0.5 ->
    (P+LastP)/2;
qs_continue(P, LS, TargetPos, _LastP, SM, _TL, _Acc) when TargetPos == LS + 0.5 ->
    qs_median(SM, TargetPos - 0.5, P, P);
qs_continue(P, LS, TargetPos, _LastP, SM, _TL, Acc) when LS + 1 > TargetPos  ->
    qs_median(SM, TargetPos, P, Acc);
qs_continue(P, LS, TargetPos, _LastP, _SM, TL, Acc) ->
    Larger = [X || X <- TL, X >= P],
    NewPos= TargetPos - LS -1,
    case NewPos == 0.5 of
        true ->
            qs_median(Larger, 1, P, P);
        false ->
            qs_median(Larger, NewPos, P, Acc)
    end.
