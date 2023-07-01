o(O) :- member(O, [0,1,2,3,4,5,6,7]).

octal([O]) :- o(O).
octal([A|B]) :-
	octal(O),
	o(T),
	append(O, [T], [A|B]),
	dif(A, 0).
	
octalize :-
	forall(
		octal(X),
		(maplist(write, X), nl)
	).
