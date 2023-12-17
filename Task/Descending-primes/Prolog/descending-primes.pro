isPrime(2).
isPrime(N):-
	between(3, inf, N),
	N /\ 1 > 0,             % odd
	M is floor(sqrt(N)) - 1, % reverse 2*I+1
	Max is M div 2,
	forall(between(1, Max, I), N mod (2*I+1) > 0).

combi(0, _, []).
combi(N, [_|T], Comb):-
    N > 0,
    combi(N, T, Comb).
combi(N, [X|T], [X|Comb]):-
    N > 0,
    N1 is N - 1,
    combi(N1, T, Comb).

descPrimes(Num):-
	between(1, 9, N),
	combi(N, [9, 8, 7, 6, 5, 4, 3, 2, 1], CList),
	atomic_list_concat(CList, Tmp), % swi specific
	atom_number(Tmp, Num),	 % int_list_to_number
	isPrime(Num).

showList(List):-
	findnsols(10, DPrim, (member(DPrim, List), writef('%9r', [DPrim])), _),
	nl,
	fail.
showList(_).
    	
do:-findall(DPrim, descPrimes(DPrim), DList),
	showList(DList).
