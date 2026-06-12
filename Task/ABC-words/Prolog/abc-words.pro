:- initialization(main, main).
:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).

abc_word -->
    string_without("abc", _), "a",
    string_without( "bc", _), "b",
    string_without(  "c", _), "c",
    remainder(_).

abc_word(ABCWord) :- once(phrase(abc_word, ABCWord)).

line_separated_words(Words) --> sequence(nonblanks, "\n", Words), blanks.

main([Filename]) :-
    phrase_from_file(line_separated_words(Words), Filename),
    include(abc_word, Words, ABCWords),
    length(ABCWords, Length),
    phrase(line_separated_words(ABCWords), ABCWordCodes),
    format("~d~n~s~n", [Length, ABCWordCodes]).

