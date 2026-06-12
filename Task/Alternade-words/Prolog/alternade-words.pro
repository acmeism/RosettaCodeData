:- dynamic dictionary_word/1.

main:-
    load_dictionary_from_file("unixdict.txt"),
    print_alternade_words(6).

load_dictionary_from_file(File):-
    open(File, read, Stream),
    retractall(dictionary_word(_)),
    load_dictionary_from_stream(Stream),
    close(Stream).

load_dictionary_from_stream(Stream):-
    read_line_to_string(Stream, String),
    String \= end_of_file,
    !,
    assertz(dictionary_word(String)),
    load_dictionary_from_stream(Stream).
load_dictionary_from_stream(_).

print_alternade_words(Min_length):-
    dictionary_word(Word),
    string_length(Word, Length),
    Length >= Min_length,
    odd_even_words(Word, Word1, Word2),
    dictionary_word(Word1),
    dictionary_word(Word2),
    writef('%10l%6l%w\n', [Word, Word1, Word2]),
    fail.
print_alternade_words(_).

odd_even_words(Word, Word1, Word2):-
    string_chars(Word, Chars),
    odd_even_chars(Chars, Chars1, Chars2),
    string_chars(Word1, Chars1),
    string_chars(Word2, Chars2).

odd_even_chars([], [], []):-!.
odd_even_chars([Ch], [Ch], []):-!.
odd_even_chars([Ch1, Ch2|Chars], [Ch1|Chars1], [Ch2|Chars2]):-
    odd_even_chars(Chars, Chars1, Chars2).
