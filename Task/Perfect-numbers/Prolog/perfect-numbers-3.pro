:- use_module(library(lambda)).

is_divisor(V, N) :-
	0 =:= V mod N.

is_perfect(N) :-
	N1 is floor(N/2),
	numlist(1, N1, L),
	f_compose_1(foldl((\X^Y^Z^(Z is X+Y)), 0), filter(is_divisor(N)), F),
	call(F, L, N).

f_perfect_numbers(N, L) :-
	numlist(2, N, LN),
	filter(is_perfect, LN, L).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% functionnal predicates

%% foldl(Pred, Init, List, R).
%
foldl(_Pred, Val, [], Val).
foldl(Pred, Val, [H | T], Res) :-
	call(Pred, Val, H, Val1),
	foldl(Pred, Val1, T, Res).

%% filter(Pred, LstIn, LstOut)
%
filter(_Pre, [], []).

filter(Pred, [H|T], L) :-
	filter(Pred, T, L1),
	(   call(Pred,H) -> L = [H|L1]; L = L1).

%% f_compose_1(Pred1, Pred2, Pred1(Pred2)).
%
f_compose_1(F,G, \X^Z^(call(G,X,Y), call(F,Y,Z))).
