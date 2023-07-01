isPrime(A):-
  	A1 is ceil(sqrt(A)),
  	between(2, A1, N),
  	0 =:= A mod N,!,
  	false.
isPrime(_).

divisors(N, Dlist):-
	N1 is floor(sqrt(N)),
	numlist(1, N1, Ds0),
	include([D]>>(N mod D =:= 0), Ds0, Ds1),
	reverse(Ds1, [Dh|Dt]),
	( Dh * Dh < N
	-> Ds1a = [Dh|Dt]
	;  Ds1a = Dt
	),
	maplist([X,Y]>>(Y is N div X), Ds1a, Ds2),
	append(Ds1, Ds2, Dlist).

longPrime(P):-
	divisors(P - 1, Dlist),
	longPrime(P, Dlist).

longPrime(_,[]):- false.
longPrime(P, [D|Dtail]):-
	powm(10, D, P) =\= 1,!,
	longPrime(P, Dtail).
longPrime(P, [D|_]):-!,
	D =:= P - 1.

isLongPrime(N):-
	isPrime(N),
	longPrime(N).

longPrimes(N, LongPrimes):-
	numlist(7, N, List),
	include(isLongPrime, List, LongPrimes).

run([]):-!.
run([Limit|Tail]):-
	statistics(runtime,[Start|_]),
	longPrimes(Limit, LongPrimes),
	length(LongPrimes, Num),
	statistics(runtime,[Stop|_]),
	Runtime is Stop - Start,
	writef('there are%5r long primes up to%6r [time (ms)%5r]\n',[Num, Limit, Runtime]),
	run(Tail).

do:-	longPrimes(500, LongPrimes),
	writeln('long primes up to 500:'),
	writeln(LongPrimes),
	numlist(0, 7, List),
	maplist([X, Y]>>(Y is 500 * 2**X), List, LimitList),
	run(LimitList).
