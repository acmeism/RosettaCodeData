:- use_module(library(dcg/basics), [string_without/4]).
:- use_module(library(dcg/high_order), [sequence/4]).
:- initialization(main, main).

lines(Lines) --> sequence(line, Lines).
line(Line)   --> string_without("\n", Line), "\n".

main([Filename]) :-
    phrase_from_file(lines(Lines), Filename),
    reverse(Lines, ReversedLines),
    phrase(lines(ReversedLines), Codes),
    format("~s", [Codes]).
