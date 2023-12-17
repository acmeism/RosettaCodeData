isPrime(2).
isPrime(N):-
	between(3, inf, N),
	N /\ 1 > 0,             % odd
	M is floor(sqrt(N)) - 1, % reverse 2*I+1
	Max is M div 2,
	forall(between(1, Max, I), N mod (2*I+1) > 0).

combi(0, _, Num, Num).
combi(N, [X|T], Acc, Num):-
    N > 0,
    N1 is N - 1,
    Acc1 is Acc * 10 + X,
    combi(N1, T, Acc1, Num).
combi(N, [_|T], Acc, Num):-
    N > 0,
    combi(N, T, Acc, Num).

ascPrimes(Num):-
	between(1, 9, N),
	combi(N, [1, 2, 3, 4, 5, 6, 7, 8, 9], 0, Num),
	isPrime(Num).

showList(List):-
	findnsols(10, DPrim, (member(DPrim, List), writef('%9r', [DPrim])), _),
	nl,
	fail.
showList(_).
    	
do:-findall(DPrim, ascPrimes(DPrim), DList),
	showList(DList).
