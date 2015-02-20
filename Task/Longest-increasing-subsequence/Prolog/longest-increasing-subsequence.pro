lis(In, Out) :-
	% we ask Prolog to find the longest sequence
	aggregate(max(N,Is), (one_is(In, [], Is), length(Is, N)), max(_, Res)),
	reverse(Res, Out).


% we describe the way to find increasing subsequence
one_is([], Current, Current).


one_is([H | T], Current, Final) :-
	(   Current = [], one_is(T, [H], Final));
	(   Current = [H1 | _], H1 < H,   one_is(T, [H | Current], Final));
	one_is(T, Current, Final).
