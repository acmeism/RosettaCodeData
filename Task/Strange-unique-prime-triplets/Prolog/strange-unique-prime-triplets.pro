primes(2, Limit):- 2 =< Limit.
primes(N, Limit):-
	between(3, Limit, N),
	N /\ 1 > 0,             % odd
	M is floor(sqrt(N)) - 1, % reverse 2*I+1
	Max is M div 2,
	forall(between(1, Max, I), N mod (2*I+1) > 0).

primeComb(N, List, Comb):-
	comb(N, List, Comb),
	sumlist(Comb, Sum),
	primes(Sum, inf).

comb(0, _, []).
comb(N, [X|T], [X|Comb]):-
	N > 0,
    N1 is N - 1,
    comb(N1, T, Comb).
comb(N, [_|T], Comb):-
    N > 0,
    comb(N, T, Comb).

tripletList(Limit, List, Len):-
	findall(N, primes(N, Limit), PrimeList),
	findall(Comb, primeComb(3, PrimeList, Comb), List),
	length(List, Len).

showList([]).
showList([[I, J, K]|TList]):-
	Sum is I + J + K,
	writef('%3r +%3r +%3r =%3r\n', [I, J, K, Sum]),
	showList(TList).

run([]).
run([Limit|TLimits]):-
	tripletList(Limit, List, Len),
	( Limit < 50
	  -> List1 = List
	  ; List1 = []
	),
	showList(List1),
	writef('number of prime Triplets up to%5r is%7r\n', [Limit, Len]),
	run(TLimits).
	
do:- run([30, 1000]).
