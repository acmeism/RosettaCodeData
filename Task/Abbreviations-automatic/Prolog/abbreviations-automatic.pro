minimum_abbreviation_length(Day_names, Min_length):-
	sort(Day_names, Sorted_names),
	minimum_abbreviation_length(Sorted_names, Min_length, 1).

minimum_abbreviation_length([_], Min_length, Min_length):- !.
minimum_abbreviation_length([Name1, Name2|Rest], Min_length, M1):-
	common_prefix_length(Name1, Name2, Length),
	M2 is max(M1, Length + 1),
	minimum_abbreviation_length([Name2|Rest], Min_length, M2).

common_prefix_length(String1, String2, Length):-
	string_chars(String1, Chars1),
	string_chars(String2, Chars2),
	common_prefix_length1(Chars1, Chars2, Length, 0).

common_prefix_length1([], _, Length, Length):-!.
common_prefix_length1(_, [], Length, Length):-!.
common_prefix_length1([C1|_], [C2|_], Length, Length):-
	C1 \= C2,
	!.
common_prefix_length1([C|Chars1], [C|Chars2], Length, L1):-
	L2 is L1 + 1,
	common_prefix_length1(Chars1, Chars2, Length, L2).

to_upper_case([], []):-!.
to_upper_case([String|S], [Upper_case|U]):-
    string_upper(String, Upper_case),
    to_upper_case(S, U).

process_line(""):-
    nl,
    !.
process_line(Line):-
    split_string(Line, "\s\t", "\s\t", Day_names),
    to_upper_case(Day_names, Upper),
    minimum_abbreviation_length(Upper, Length),
    writef('%w %w\n', [Length, Line]).

process_stream(Stream):-
    read_line_to_string(Stream, String),
    String \= end_of_file,
    !,
    process_line(String),
    process_stream(Stream).
process_stream(_).

process_file(File):-
    open(File, read, Stream),
    process_stream(Stream),
    close(Stream).

main:-
    process_file("days_of_week.txt").
