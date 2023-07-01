task1 :-
	hailstone(27),
	findall(X, find_chr_constraint(hailstone(X)), L),
	clean,
	% check the requirements
	(   (length(L, 112), append([27, 82, 41, 124 | _], [8,4,2,1], L)) -> writeln(ok); writeln(ko)).
