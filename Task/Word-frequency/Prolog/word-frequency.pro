print_top_words(File, N):-
    read_file_to_string(File, String, [encoding(utf8)]),
    re_split("\\w+", String, Words),
    lower_case(Words, Lower),
    sort(1, @=<, Lower, Sorted),
    merge_words(Sorted, Counted),
    sort(2, @>, Counted, Top_words),
    writef("Top %w words:\nRank\tCount\tWord\n", [N]),
    print_top_words(Top_words, N, 1).

lower_case([_], []):-!.
lower_case([_, Word|Words], [Lower - 1|Rest]):-
    string_lower(Word, Lower),
    lower_case(Words, Rest).

merge_words([], []):-!.
merge_words([Word - C1, Word - C2|Words], Result):-
    !,
    C is C1 + C2,
    merge_words([Word - C|Words], Result).
merge_words([W|Words], [W|Rest]):-
    merge_words(Words, Rest).

print_top_words([], _, _):-!.
print_top_words(_, 0, _):-!.
print_top_words([Word - Count|Rest], N, R):-
    writef("%w\t%w\t%w\n", [R, Count, Word]),
    N1 is N - 1,
    R1 is R + 1,
    print_top_words(Rest, N1, R1).

main:-
    print_top_words("135-0.txt", 10).
