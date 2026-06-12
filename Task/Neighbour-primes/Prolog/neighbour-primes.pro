primes(2, Limit):- 2 =< Limit.
primes(P, Limit):-
	between(3, Limit, P),
	P /\ 1 > 0,             % odd
	M is floor(sqrt(P)) - 1, % reverse 2*I+1
	Max is M div 2,
	forall(between(1, Max, I), P mod (2*I+1) > 0).

isPrime(P):-
	primes(P, inf).

primeProd(PList, [P1, P2]):-
	append(_, [P1, P2| _], PList),
	Prod is P1 * P2 + 2,
	isPrime(Prod).

showList(List):-
	findnsols(10, _, (member(Pair, List), format('~|~t(~d,~d)~9+ ', Pair)), _),
	nl,
	fail.
showList(_).

do:-Limit is 500,
	findall(P, primes(P, Limit), PrimeList),
	findall(Pair, primeProd(PrimeList, Pair), P1P2List),
	showList(P1P2List).
