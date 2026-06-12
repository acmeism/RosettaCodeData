steadySquare([], _, []).
steadySquare([N| NTail], Modulo, SteadyList):-
	Modulo =< N,!,
	Modulo1 is Modulo * 10,
	steadySquare([N| NTail], Modulo1, SteadyList).
steadySquare([N| NTail], Modulo, [N| SteadyList]):-
	N ^ 2 mod Modulo =:= N,!,
	steadySquare(NTail, Modulo, SteadyList).
steadySquare([_| NTail], Modulo, SteadyList):-
	steadySquare(NTail, Modulo, SteadyList).

candidateList(Limit, List):-
	candidateList(5, Limit, List0),
	append([0,1], List0, List).

candidateList(N, Limit, [N, N1| Tail]):-
	N < Limit,!,
	N1 is N + 1,
	N10 is N + 10,
	candidateList(N10, Limit, Tail).
candidateList(_, _, []).

showList(_, []):-!.
showList(FrmStr, [StSquare| Tail]):-
	Sqr is StSquare ^ 2,
	format(FrmStr, [StSquare, Sqr]),
	showList(FrmStr, Tail).
	
do:- candidateList(1000000, List),
	steadySquare(List, 1, SteadySquareList),
	last(SteadySquareList, LastStSqr),
	LastLen is 1 + floor(log10(LastStSqr)),
	LastSqrLen is 1 + floor(log10(LastStSqr ^ 2)),
	swritef(FrmStr, '~|~t~d~%d+ ~|~t~d~%d+~n', [LastLen, LastSqrLen]),
	showList(FrmStr, SteadySquareList).
