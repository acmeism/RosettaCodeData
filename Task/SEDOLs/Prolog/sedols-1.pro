:- set_prolog_flag(double_quotes, codes).
:- use_module(library(clpfd)).

sedol -->
    sdigit(S1), sdigit(S2), sdigit(S3), sdigit(S4), sdigit(S5), sdigit(S6), sdigit(S7),
    {   S7 in 0..9,
        (S1 + S2 * 3 + S3 + S4 * 7 + S5 * 3 + S6 * 9 + S7) mod 10 #= 0
    }.

sdigit(Value) --> [Code],
    {   Value in 0..35,
        Code in 48..57\/66..68\/70..72\/74..78\/80..84\/86..90,
        Code in 48..57 #<==> Value #= Code - 48,
        Code in 66..90 #<==> Value #= Code - 55
    }.

add_checksum_digit(SEDOL6, SEDOL7) :-
    append(SEDOL6, [_], SEDOL7),
    phrase(sedol, SEDOL7),
    once(label(SEDOL7)).

% adds the checksum digits to each number and removes any invalid numbers
task(SEDOL6s) :-
    convlist(add_checksum_digit, SEDOL6s, SEDOL7s),
    foreach(member(SEDOL7, SEDOL7s), format("~s~n", [SEDOL7])).

?- task([
      "710889",
      "B0YBKJ",
      "406566",
      "B0YBLH",
      "228276",
      "B0YBKL",
      "557910",
      "B0YBKR",
      "585284",
      "B0YBKT",
      "BOYBKT", % Ill formed test case - illegal vowel.
      "B00030"
    ]).
