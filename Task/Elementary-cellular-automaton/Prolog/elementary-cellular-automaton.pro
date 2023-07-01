play :-	initial(I), do_auto(50, I).

initial([0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0]).

do_auto(0, _) :- !.
do_auto(N, I) :-
	maplist(writ, I), nl,
	apply_rules(I, Next),
	succ(N1, N),
	do_auto(N1, Next).

r(0,0,0,0).
r(0,0,1,1).
r(0,1,0,0).
r(0,1,1,1).
r(1,0,0,1).
r(1,0,1,0).
r(1,1,0,1).
r(1,1,1,0).

apply_rules(In, Out) :-
	apply1st(In, First),
	Out = [First|_],
	apply(In, First, First, Out).

apply1st([A,B|T], A1) :-                            last([A,B|T], Last), r(Last,A,B,A1).
apply([A,B], Prev, First, [Prev, This]) :-          r(A,B,First,This).
apply([A,B,C|T], Prev, First, [Prev,This|Rest]) :-  r(A,B,C,This), apply([B,C|T], This, First, [This|Rest]).

writ(0) :- write('.').
writ(1) :- write(1).
