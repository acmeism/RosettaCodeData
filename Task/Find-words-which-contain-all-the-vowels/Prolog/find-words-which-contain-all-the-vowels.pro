% usage: swipl all_the_vowels.pl [filename]
:- initialization(main, main).
:- use_module(library(dcg/basics), [nonblanks/3]).
:- use_module(library(dcg/high_order), [sequence/4]).

lines(Lines) --> sequence(line, Lines).
line(Line)   --> nonblanks(Line), "\n".

contains_all_vowels(Word) :-
    length(Word, Length),
    Length > 10,
    msort(Word, Sorted),
    clumped(Sorted, Clumps),
    ord_subset([0'a-1, 0'e-1, 0'i-1, 0'o-1, 0'u-1], Clumps).

main([]) :- main(['unixdict.txt']).
main([Filename]) :-
    once(phrase_from_file(lines(Lines), Filename)),
    include(contains_all_vowels, Lines, Words),
    once(phrase(lines(Words), Codes)),
    format("~s~n", [Codes]).
