task(1) :-
	between(1, 11, I),
	farey(I, F),
	write(I), write(': '),
	rwrite(F), nl, fail; true.

task(2) :- between(1, 10, I),
	I100 is I*100,
	farey( I100, F),
	length(F,N),
	write('|F('), write(I100), write(')| = '), writeln(N), fail; true.

% farey(+Order, Sequence)
farey(Order, Sequence) :-
  bagof( R,
	 I^J^(between(1, Order, J), between(0, J, I), R is I rdiv J),
	 S),
  predsort( rcompare, S, Sequence ).

rprint( rdiv(A,B) ) :- write(A), write(/), write(B), !.
rprint( I ) :- integer(I), write(I), write(/), write(1), !.

rwrite([]).
rwrite([R]) :- rprint(R).
rwrite([R, T|Rs]) :- rprint(R), write(', '), rwrite([T|Rs]).

rcompare(<, A, B) :- A < B, !.
rcompare(>, A, B) :- A > B, !.
rcompare(=, A, B) :- A =< B.
