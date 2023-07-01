report_duplicates(S) :-
	duplicates(S, Dups),		
	format('For value "~w":~n', S),
	report(Dups),
	nl.
	
report(Dups) :-
	maplist(only_one_position, Dups),
	format('    All characters are unique~n').
	
report(Dups) :-
	exclude(only_one_position, Dups, [c(Char,Positions)|_]),
	reverse(Positions, PosInOrder),
	atomic_list_concat(PosInOrder, ', ', PosAsList),
	format('    The character ~w is non unique at ~p~n', [Char, PosAsList]).	
	
only_one_position(c(_,[_])).	
	
duplicates(S, Count) :-
	atom_chars(S, Chars),
	char_count(Chars, 0, [], Count).
		
char_count([], _, C, C).
char_count([C|T], Index, Counted, Result) :-
	select(c(C,Positions), Counted, MoreCounted),
	succ(Index, Index1),
	char_count(T, Index1, [c(C,[Index|Positions])|MoreCounted], Result).
char_count([C|T], Index, Counted, Result) :-
	\+ member(c(C,_), Counted),
	succ(Index, Index1),
	char_count(T, Index1, [c(C,[Index])|Counted], Result).
	
test :-	report_duplicates('').
test :-	report_duplicates('.').
test :-	report_duplicates('abcABC').
test :-	report_duplicates('XYZ ZYX').
test :-	report_duplicates('1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ').
