isPrime(2).
isPrime(N):-
	between(3, inf, N),
	N /\ 1 > 0,             % odd
	M is floor(sqrt(N)) - 1, % reverse 2*I+1
	Max is M div 2,
	forall(between(1, Max, I), N mod (2*I+1) > 0).

primeSum([], _, _, []).
primeSum([P|PList], Index, Acc, [Index|CList]):-
	Sum is Acc + P,
	isPrime(Sum),!,
	format('~|~t~d~3+  ~|~t~d~3+  ~|~t~d~5+', [Index, P, Sum]),nl,
	Index1 is Index + 1,
	primeSum(PList, Index1, Sum, CList).
primeSum([P|PList], Index, Acc, CntList):-
	Index1 is Index + 1,
	Sum is Acc + P,
	primeSum(PList, Index1, Sum, CntList).

do:-Limit is 1000,
	numlist(1, Limit, List),
	include(isPrime, List, PrimeList),
	primeSum(PrimeList, 1, 0, CntList),
	length(CntList, Number),
	format('~nfound ~d such primes~n', [Number]).
