play :- random_numbers(L), do_turn(0,L), !.

do_turn(N, L) :-
	print_list(L),
	how_many_to_flip(F),
	flip(L,F,[],Lnew),
	succ(N,N1),
	sorted(N1,Lnew).

how_many_to_flip(F) :-
	read_line_to_codes(user_input, Line),
	number_codes(F, Line),
	between(1,9,F).
	
flip(L,0,C,R) :- append(C,L,R).
flip([Ln|T],N,C,R) :- dif(N,0), succ(N0,N), flip(T,N0,[Ln|C],R).
	
sorted(N,L) :-
	sort(L,L)
	-> print_list(L), format('-> ~p~n', N)
	; do_turn(N,L).	

random_numbers(L) :- random_permutation([1,2,3,4,5,6,7,8,9],L).

print_list(L) :-
	atomic_list_concat(L, ' ', Lf),
	format('(~w) ',Lf).
