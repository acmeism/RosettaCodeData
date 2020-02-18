:- use_module(library(clpfd)).

% Basic, Q = Quarter, D = Dime, N = Nickel, P = Penny
coins(Q, D, N, P, T) :-
	[Q,D,N,P] ins 0..T,
	T #= (Q * 25) + (D * 10) + (N * 5) + P.

coins_for(T) :-
	coins(Q,D,N,P,T),
	maplist(indomain, [Q,D,N,P]).
