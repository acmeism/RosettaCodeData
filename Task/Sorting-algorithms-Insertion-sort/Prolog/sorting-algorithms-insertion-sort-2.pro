% insertion sort
isort(L, LS) :-
	foldl(insert, [], L, LS).


% foldl(Pred, Init, List, R).
foldl(_Pred, Val, [], Val).
foldl(Pred, Val, [H | T], Res) :-
	call(Pred, Val, H, Val1),
	foldl(Pred, Val1, T, Res).

% insertion in a sorted list
insert([], N, [N]).

insert([H | T], N, [N, H|T]) :-
	N =< H, !.

insert([H | T], N, [H|L1]) :-
	insert(T, N, L1).
