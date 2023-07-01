hofstadter :-
	hofstadter(960),
	% fetch the values of ffr
	bagof(Y, X^find_chr_constraint(ffs(X,Y)), L1),
	% fetch the values of ffs
	bagof(Y, X^(find_chr_constraint(ffr(X,Y)), X < 41), L2),
	% concatenate then
	append(L1, L2, L3),
	% sort removing duplicates
	sort(L3, L4),
	% check the correctness of the list
	(   (L4 = [1|_], last(L4, 1000), length(L4, 1000)) -> writeln(ok); writeln(ko)),
	% to remove all pending constraints
	fail.
