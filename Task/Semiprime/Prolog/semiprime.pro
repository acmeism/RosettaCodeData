factors(N, FList):-
	factors(N, 2, 0, FList).

factors(1, _, _Count, []).
factors(_, _, Count, []):- Count > 1. % break on 2 factors reached
factors(N, Start, Count, [Fac|FList]):-
	N1 is floor(sqrt(N)),
	between(Start, N1, Fac),
	N mod Fac =:= 0,!,
	N2 is N div Fac,
	Count1 is Count + 1,
	factors(N2, Fac, Count1, FList).
factors(N, _, _, [N]):- N >= 2.

semiPrimeList(Limit, List):-
	findall(N, semiPrimes(2, Limit, N), List).

semiPrimes(Start, Limit, N):-
	between(Start, Limit, N),
	factors(N, [F1, F2]),
	N =:= F1 * F2.	% correct factors break

do:- semiPrimeList(100, SemiPrimes),
	writeln(SemiPrimes),
	findall(N, semiPrimes(1675, 1685, N), SemiPrimes2),
	writeln(SemiPrimes2).
