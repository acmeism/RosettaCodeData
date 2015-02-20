abc_problem :-
	maplist(abc_problem, ['', 'A', bark, bOOk, treAT, 'COmmon', sQuaD, 'CONFUSE']).


abc_problem(Word) :-
	L = [[b,o],[x,k],[d,q],[c,p],[n,a],[g,t],[r,e],[t,g],[q,d],[f,s],
	     [j,w],[h,u],[v,i],[a,n],[o,b],[e,r],[f,s],[l,y],[p,c],[z,m]],

	(   abc_problem(L, Word)
	->  format('~w OK~n', [Word])
	;   format('~w KO~n', [Word])).

abc_problem(L, Word) :-
	atom_chars(Word, C_Words),
	maplist(downcase_atom, C_Words, D_Words),
	can_makeword(L, D_Words).

can_makeword(_L, []).

can_makeword(L, [H | T]) :-
	(   select([H, _], L, L1); select([_, H], L, L1)),
	can_makeword(L1, T).
