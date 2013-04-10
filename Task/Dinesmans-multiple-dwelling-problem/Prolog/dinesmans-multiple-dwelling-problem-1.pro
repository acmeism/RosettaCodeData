:- use_module(library(clpfd)).

:- dynamic top/1, bottom/1.

% Baker does not live on the top floor
rule1(L) :-
	member((baker, F), L),
	top(Top),
	F #\= Top.

% Cooper does not live on the bottom floor.
rule2(L) :-
	member((cooper, F), L),
	bottom(Bottom),
	F #\= Bottom.

% Fletcher does not live on either the top or the bottom floor.
rule3(L) :-
	member((fletcher, F), L),
	top(Top),
	bottom(Bottom),
	F #\= Top,
	F #\= Bottom.

% Miller lives on a higher floor than does Cooper.
rule4(L) :-
	member((miller, Fm), L),
	member((cooper, Fc), L),
	Fm #> Fc.

% Smith does not live on a floor adjacent to Fletcher's.
rule5(L) :-
	member((smith, Fs), L),
	member((fletcher, Ff), L),
	abs(Fs-Ff) #> 1.

% Fletcher does not live on a floor adjacent to Cooper's.
rule6(L) :-
	member((cooper, Fc), L),
	member((fletcher, Ff), L),
	abs(Fc-Ff) #> 1.

init(L) :-
	% we need to define top and bottom
	assert(bottom(1)),
	length(L, Top),
	assert(top(Top)),

	% we say that they are all in differents floors
	bagof(F, X^member((X, F), L), LF),
	LF ins 1..Top,
	all_different(LF),

	% Baker does not live on the top floor
	rule1(L),

	% Cooper does not live on the bottom floor.
	rule2(L),

	% Fletcher does not live on either the top or the bottom floor.
	rule3(L),

	% Miller lives on a higher floor than does Cooper.
	rule4(L),

	% Smith does not live on a floor adjacent to Fletcher's.
	rule5(L),

	% Fletcher does not live on a floor adjacent to Cooper's.
	rule6(L).


solve(L) :-
	bagof(F, X^member((X, F), L), LF),
	label(LF).

dinners :-
	retractall(top(_)), retractall(bottom(_)),
	L = [(baker, _Fb), (cooper, _Fc), (fletcher, _Ff), (miller, _Fm), (smith, _Fs)],
	init(L),
	solve(L),
	maplist(writeln, L).
