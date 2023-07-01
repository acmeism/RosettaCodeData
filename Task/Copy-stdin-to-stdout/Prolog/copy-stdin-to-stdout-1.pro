%File: stdin_to_stdout.pl
:- initialization(main).

main :- repeat,
	get_char(X),
	put_char(X),
	X == end_of_file,
	fail.
