% foldl(Pred, Init, List, R).
%
foldl(_Pred, Val, [], Val).
foldl(Pred, Val, [H | T], Res) :-
	call(Pred, Val, H, Val1),
	foldl(Pred, Val1, T, Res).

% factorial
p(X, Y, Z) :- Z is X * Y).

fact(X, F) :-
	numlist(2, X, L),
	foldl(p, 1, L, F).
