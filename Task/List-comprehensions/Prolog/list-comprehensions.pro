% We need operators
:- op(700, xfx, <-).
:- op(450, xfx, ..).
:- op(1100, yfx, &).

% use for explicit list usage
my_bind(V, [H|_]) :- V = H.
my_bind(V, [_|T]) :- my_bind(V, T).

% we need to define the intervals of numbers
Vs <- M..N :-
        integer(M),
	integer(N),
	M =< N,
	between(M, N, Vs).

% for explicit list comprehension like Vs <- [1,2,3]
Vs <- Xs :-
	is_list(Xs),
	my_bind(Vs, Xs).

% finally we define list comprehension
% prototype is Vs <- {Var, Dec, Pred} where
% Var is the list of variables to output
% Dec is the list of intervals of the variables
% Pred is the list of predicates
Vs <- {Var & Dec & Pred} :-
	findall(Var,  maplist(call, [Dec, Pred]), Vs).

% for list comprehension without Pred
Vs <- {Var & Dec} :-
	findall(Var, maplist(call, [Dec]), Vs).
