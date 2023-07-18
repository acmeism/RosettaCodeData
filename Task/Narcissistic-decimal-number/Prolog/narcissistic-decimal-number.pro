digits(0, []):-!.
digits(N, [D|DList]):-
	divmod(N, 10, N1, D),
	digits(N1, DList).

combi(0, _, []).
combi(N, [X|T], [X|Comb]):-
	N > 0,
	N1 is N - 1,
	combi(N1, [X|T], Comb).
combi(N, [_|T], Comb):-
	N > 0,
	combi(N, T, Comb).

powSum([], _, Sum, Sum).
powSum([D|DList], Pow, Acc, Sum):-
	Acc1 is Acc + D^Pow,
	powSum(DList, Pow, Acc1, Sum).

armstrong(Exp, PSum):-
	numlist(0, 9, DigList),
	(Exp > 1 ->
	  Min is 10^(Exp - 1)
	  ; Min is 0
	),
	Max is 10^Exp - 1,
	combi(Exp, DigList, Comb),
	powSum(Comb, Exp, 0, PSum),
	between(Min, Max, PSum),
	digits(PSum, DList),
	sort(0, @=<, DList, DSort),	% hold equal digits
	( DSort = Comb;
      PSum =:= 0,	% special case because
	  Comb = [0]	% DList in digits(0, DList) is [] and not [0]
	).
	
do:-between(1, 7, Exp),
	findall(ArmNum, armstrong(Exp, ArmNum), ATemp),
	sort(ATemp, AList),
	writef('%d -> %w\n', [Exp, AList]),
	fail.
do.
