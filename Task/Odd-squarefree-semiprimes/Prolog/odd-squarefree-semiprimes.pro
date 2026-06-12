oddPrimes(3, Limit):- 3 =< Limit.
oddPrimes(N, Limit):-
	between(5, Limit, N),
	N /\ 1 > 0,             % odd
	N mod 3 > 0,		    % \= 3*i
	M is floor(sqrt(N)) + 1, % reverse 6*I-1
	Max is M div 6,
	forall(between(1, Max, I), (N mod (6*I-1) > 0, N mod (6*I+1) > 0)).

merge([], Sort, Sort).
merge([X|Sort1], [Y|Sort2], [X|Sort]):-
	X < Y,!,
	merge(Sort1, [Y|Sort2], Sort).
merge(Sort1, [Y|Sort2], [Y|Sort]):-
	merge(Sort2, Sort1, Sort).

semiPrimes(PList, Limit, SpList):-
	semiPrimes(PList, Limit, [], SpList).

semiPrimes([], _, Acc, Acc).	% odd, squarefree generator
semiPrimes([P|PList], Limit, Acc, SpList):-
	findall(Sp, (member(X, PList), X =< Limit div P, Sp is P * X), MList),
	MList = [_|_],!,
	merge(Acc, MList, Acc1),
	semiPrimes(PList, Limit, Acc1, SpList).
semiPrimes(_, _, Acc, Acc).

showList(List):-
	findnsols(20, X, (member(X, List), writef('%4r', [X])), _SubList), nl,
	fail.
showList(_).
	
do:-Limit is 1000,
	PLimit is Limit div 3,
	findall(N, oddPrimes(N, PLimit), PList),
	semiPrimes(PList, Limit, SpList),!,
	showList(SpList).
