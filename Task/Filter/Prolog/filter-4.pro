:- use_module(lambda).

%% filter(Pred, LstIn, LstOut)
%%
filter(_Pre, [], []).

filter(Pred, [H|T], L) :-
	filter(Pred, T, L1),
	(   call(Pred,H) -> L = [H|L1]; L = L1).
