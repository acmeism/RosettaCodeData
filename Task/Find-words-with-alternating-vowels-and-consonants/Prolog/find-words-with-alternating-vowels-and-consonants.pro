main:-
    open("unixdict.txt", read, Stream),
    main(Stream, 0),
    close(Stream).

main(Stream, Count):-
    read_line_to_string(Stream, String),
    String \= end_of_file,
    !,
    process_line(String, Count, Count1),
    main(Stream, Count1).
main(_, _).

process_line(String, Count, Count1):-
    string_chars(String, Chars),
    length(Chars, Length),
    Length > 9,
    alternating_vowels_and_consonants(Chars),
    !,
    Count1 is Count + 1,
    writef('%3r: %w\n', [Count1, String]).
process_line(_, Count, Count).

vowel('a').
vowel('e').
vowel('i').
vowel('o').
vowel('u').

alternating_vowels_and_consonants([_]):-!.
alternating_vowels_and_consonants([Ch1, Ch2|Chars]):-
    (vowel(Ch1) -> \+vowel(Ch2) ; vowel(Ch2)),
    alternating_vowels_and_consonants([Ch2|Chars]).
