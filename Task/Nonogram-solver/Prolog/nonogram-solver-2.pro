nonogram :-
	open('C:/Users/Utilisateur/Documents/Prolog/Rosetta/nonogram/nonogram.txt',
	     read, In, []),
	repeat,
	     read_line_to_codes(In, Line_1),
	     read_line_to_codes(In, Line_2),
	     compute_values(Line_1, [], [], Lines),
	     compute_values(Line_2, [], [], Columns),
	     nonogram(Lines, Columns) , nl, nl,
	read_line_to_codes(In, end_of_file),
	close(In).

compute_values([], Current, Tmp, R) :-
	reverse(Current, R_Current),
	reverse([R_Current | Tmp], R).

compute_values([32 | T], Current, Tmp, R) :-
	!,
	reverse(Current, R_Current),
	compute_values(T, [], [R_Current | Tmp], R).

compute_values([X | T], Current, Tmp, R) :-
	V is X - 64,
	compute_values(T, [V | Current], Tmp, R).
