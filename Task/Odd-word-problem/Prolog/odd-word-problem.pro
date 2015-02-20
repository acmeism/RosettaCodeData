odd_word_problem :-
	read_line_to_codes(user_input, L),
	even_word(L, Out, []),
	string_to_list(Str, Out),
	writeln(Str).

even_word(".") --> ".".

even_word([H | T]) -->
	{char_type(H,alnum)},
	[H],
	even_word(T).

even_word([H | T]) -->
	[H],
	odd_word(T, []).

odd_word(".", R) --> R, ".".

odd_word([H|T], R) -->
	{char_type(H,alnum)},
	odd_word(T, [H | R]).

odd_word([H|T], R) -->
	R,
	[H],
	even_word(T).
