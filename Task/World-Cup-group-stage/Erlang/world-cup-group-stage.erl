-module(world_cup).

-export([group_stage/0]).

group_stage() ->
	Results = [[3,0],[1,1],[0,3]],
	Teams = [1,2,3,4],
	Matches = combos(2,Teams),
	AllResults =
		combinations(Matches,Results),
	AllPoints =
		[lists:flatten([lists:zip(L1,L2) || {L1,L2} <- L]) || L <- AllResults],
	TotalPoints =
		[ [ {T,lists:sum([Points || {T_,Points} <- L, T_ == T])} || T <- Teams] || L <- AllPoints],
	SortedTotalPoints =
		[ lists:sort(fun({_,A},{_,B}) -> A > B end,L) || L <- TotalPoints],
	PointsPosition =
		[ [element(2,lists:nth(N, L))|| L <- SortedTotalPoints ] || N <- Teams],
	[ [length(lists:filter(fun(Points_) -> Points_ == Points end,lists:nth(N, PointsPosition) ))
		|| Points <- lists:seq(0,9)] || N <- Teams].

combos(1, L) ->
	[[X] || X <- L];
combos(K, L) when K == length(L) ->
	[L];
combos(K, [H|T]) ->
    [[H | Subcombos] || Subcombos <- combos(K-1, T)]
    ++ (combos(K, T)).

combinations([H],List2) ->
	[[{H,Item}] || Item <- List2];
combinations([H|T],List2) ->
	[ [{H,Item} | Comb] || Item <- List2, Comb <- combinations(T,List2)].
