:- dynamic dictionary_word/1.

main:-
    load_dictionary_from_file("unixdict.txt", 6),
    forall((dictionary_word(Word1),
            string_chars(Word1, Chars1),
            memberchk('e', Chars1),
            replace('e', 'i', Chars1, Chars2),
            string_chars(Word2, Chars2),
            dictionary_word(Word2)),
            writef('%10l -> %w\n', [Word1, Word2])).

load_dictionary_from_file(File, Min_length):-
    open(File, read, Stream),
    retractall(dictionary_word(_)),
    load_dictionary_from_stream(Stream, Min_length),
    close(Stream).

load_dictionary_from_stream(Stream, Min_length):-
    read_line_to_string(Stream, String),
    String \= end_of_file,
    !,
    string_length(String, Length),
    (Length >= Min_length -> assertz(dictionary_word(String)) ; true),
    load_dictionary_from_stream(Stream, Min_length).
load_dictionary_from_stream(_, _).

replace(_, _, [], []):-!.
replace(Ch1, Ch2, [Ch1|Chars1], [Ch2|Chars2]):-
    !,
    replace(Ch1, Ch2, Chars1, Chars2).
replace(Ch1, Ch2, [Ch|Chars1], [Ch|Chars2]):-
    replace(Ch1, Ch2, Chars1, Chars2).
