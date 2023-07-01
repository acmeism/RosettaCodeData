:- use_module(lambda).

% foldl(Pred, Init, List, R).
%
foldl(_Pred, Val, [], Val).
foldl(Pred, Val, [H | T], Res) :-
	call(Pred, Val, H, Val1),
	foldl(Pred, Val1, T, Res).

fact(N, F) :-
	numlist(2, N, L),
	foldl(\X^Y^Z^(Z is X * Y), 1, L, F).
