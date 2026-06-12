firstSqr(Num, Sqr):-
	Start is ceil(sqrt(Num)),
	NumLen is floor(log10(Num)) + 1,
	between(Start, inf, N),
	Sqr is N * N,
	SqrLen is floor(log10(Sqr)) + 1,
	Num =:= Sqr div 10**(SqrLen - NumLen),!.

showList(List):-
	findnsols(7, _, (member(NumSqr, List), writef('%3r ->%6r', NumSqr)), _),
	nl,
	fail.
showList(_).

do:-findall([Num, Sqr], (between(1, 49, Num), firstSqr(Num, Sqr)), NumSqrList),
	showList(NumSqrList).
