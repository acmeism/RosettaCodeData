common_prefix(String1, String2, Prefix):-
    string_chars(String1, Chars1),
    string_chars(String2, Chars2),
    common_prefix1(Chars1, Chars2, Chars),
    string_chars(Prefix, Chars).

common_prefix1([], _, []):-!.
common_prefix1(_, [], []):-!.
common_prefix1([C1|_], [C2|_], []):-
    C1 \= C2,
    !.
common_prefix1([C|Chars1], [C|Chars2], [C|Chars]):-
    common_prefix1(Chars1, Chars2, Chars).

lcp([], ""):-!.
lcp([String], String):-!.
lcp(List, Prefix):-
    min_member(Min, List),
    max_member(Max, List),
    common_prefix(Min, Max, Prefix).

test(Strings):-
    lcp(Strings, Prefix),
    writef('lcp(%t) = %t\n', [Strings, Prefix]).

main:-
    test(["interspecies", "interstellar", "interstate"]),
    test(["throne", "throne"]),
    test(["throne", "dungeon"]),
    test(["throne", "", "throne"]),
    test(["cheese"]),
    test([""]),
    test([]),
    test(["prefix", "suffix"]),
    test(["foo", "foobar"]).
