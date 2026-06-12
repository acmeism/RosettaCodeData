:- dynamic dictionary_word/1.

main:-
    File_name = 'unixdict.txt',
    load_dictionary_from_file(File_name, 12),
    print_changeable_words(File_name).

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
    (Length >= Min_length ->
        assertz(dictionary_word(String))
        ;
        true),
    load_dictionary_from_stream(Stream, Min_length).
load_dictionary_from_stream(_, _).

print_changeable_words(File_name):-
    writef('Changeable words in %w:\n', [File_name]),
    findall([Word1, Word2],
            (dictionary_word(Word1),
             dictionary_word(Word2),
             Word1 \= Word2,
             hamming_distance(Word1, Word2, 1)),
            Words),
    nth1(N, Words, [Word1, Word2]),
    writef('%3r: %15l-> %w\n', [N, Word1, Word2]),
    fail.
print_changeable_words(_).

hamming_distance(String1, String2, Dist):-
    string_chars(String1, Chars1),
    string_chars(String2, Chars2),
    hamming_distance(Chars1, Chars2, Dist, 0).

hamming_distance([], [], Dist, Dist):-!.
hamming_distance([Ch|Chars1], [Ch|Chars2], Dist, Count):-
    !,
    hamming_distance(Chars1, Chars2, Dist, Count).
hamming_distance([_|Chars1], [_|Chars2], Dist, Count):-
    Count1 is Count + 1,
    Count1 < 2,
    hamming_distance(Chars1, Chars2, Dist, Count1).
