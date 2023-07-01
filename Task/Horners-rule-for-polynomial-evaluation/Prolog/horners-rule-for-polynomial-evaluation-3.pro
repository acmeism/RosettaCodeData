:- use_module(library(lambda)).


% foldr(Pred, Init, List, R).
%
foldr(_Pred, Val, [], Val).
foldr(Pred, Val, [H | T], Res) :-
	foldr(Pred, Val, T, Res1),
	call(Pred, Res1, H, Res).

f_horner(L, V, R) :-
	foldr(\X^Y^Z^(Z is X * V + Y), 0, L, R).
