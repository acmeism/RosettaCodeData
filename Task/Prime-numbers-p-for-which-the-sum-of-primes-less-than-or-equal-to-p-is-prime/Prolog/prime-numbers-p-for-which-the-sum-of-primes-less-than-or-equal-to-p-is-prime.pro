primes(2, Limit):- 2 =< Limit.
primes(3, Limit):- 3 =< Limit.
primes(N, Limit):-
	between(5, Limit, N),
	N /\ 1 > 0,             % odd
	N mod 3 > 0,		    % /= 3*i
	M is floor(sqrt(N)) + 1, % reverse 6*I-1
	Max is M div 6,
	forall(between(1, Max, I), (N mod (6*I-1) > 0, N mod (6*I+1) > 0)).

isPrime(N):-
	primes(N, inf).

primeSum(List, LastP):-
	append(SubList, _, List),
	sum_list(SubList, Sum),
	isPrime(Sum),
	last(SubList, LastP).

showList(List):-
	last(List, Last),
	FmtLen is 2 + floor(log10(Last)),	% one more for space
	swritef(FmtStr, '%%dr', [FmtLen]),
	findnsols(10, X, (member(X, List), writef(FmtStr, [X])), _), nl,
	fail.
showList(_).

do(Limit):-
	findall(N, primes(N, Limit), PrimeList),
	findall(LastP, primeSum(PrimeList, LastP), SumList),
	showList(SumList).

do:- do(2000).
