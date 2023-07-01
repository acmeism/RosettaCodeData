make_table(S,E) :-
	print_header(S,E),
	make_table_rows(S,E),
	fail.
make_table(_,_).

print_header(S,E) :-
	nl,
	write('      '),
	forall(between(S,E,X), print_num(X)),
	nl,
	Sp is E * 4 + 2,
	write('    '),
	forall(between(1,Sp,_), write('-')).
	
make_table_rows(S,E) :-
	between(S,E,N),
	nl,
	print_num(N), write(': '),
	between(S,E,N2),
	X is N * N2,
	print_row_item(N,N2,X).
	
print_row_item(N, N2, _) :-
	N2 < N,
	write('    ').
print_row_item(N, N2, X) :-
	N2 >= N,
	print_num(X).
	
print_num(X) :- X < 10,	          format('   ~p', X).
print_num(X) :- between(10,99,X), format('  ~p', X).
print_num(X) :- X > 99,	          format(' ~p', X).
