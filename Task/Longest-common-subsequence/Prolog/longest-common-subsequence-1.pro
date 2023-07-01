test :-
    time(lcs("thisisatest", "testing123testing", Lcs)),
    writef('%s',[Lcs]).

	
lcs([ H|L1],[ H|L2],[H|Lcs]) :- !,
    lcs(L1,L2,Lcs).

lcs([H1|L1],[H2|L2],Lcs):-
    lcs(    L1 ,[H2|L2],Lcs1),
    lcs([H1|L1],    L2 ,Lcs2),
    longest(Lcs1,Lcs2,Lcs),!.

lcs(_,_,[]).


longest(L1,L2,Longest) :-
    length(L1,Length1),
    length(L2,Length2),
    ((Length1 > Length2) -> Longest = L1; Longest = L2).
