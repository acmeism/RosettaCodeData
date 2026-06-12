isPrime(2).                 % prime generator
isPrime(N):-
	between(3, inf, N),
	N /\ 1 > 0,             % odd
	M is floor(sqrt(N)) - 1, % reverse 2*I+1
	Max is M div 2,
	forall(between(1, Max, I), N mod (2*I+1) > 0).

do:- Index is 10001,
	findnsols(Index, N, isPrime(N), PrimeList),!,
	last(PrimeList, PrimeAtIndex),
	format('prime(~d) is ~d', [Index, PrimeAtIndex]), nl.
