:- initialization(main, main).
:- use_module(library(apply)).
:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).
:- use_module(library(ordsets)).

load(Filename, Words) :- once(phrase_from_file(sequence(word, Words), Filename)).
word(Word) --> nonblanks(Word), eol, { Word \= [] }.

find_all_semordnilaps(Words, Semordnilaps) :-
    convlist([Word, Reversed] >> (
        reverse(Word, Reversed),
        Reversed @< Word
    ), Words, ReversedWords0),
    sort(ReversedWords0, ReversedWords),
    ord_intersection(Words, ReversedWords, Semordnilaps).

main([Filename]) :-
    load(Filename, Words),
    find_all_semordnilaps(Words, Semordnilaps),
    length(Semordnilaps, Count),
    format("~d~n", Count),
    length(FirstFive, 5),
    prefix(FirstFive, Semordnilaps),
    maplist([Word] >> (
        reverse(Word, Reversed),
        format("~s / ~s~n", [Word, Reversed])
    ), FirstFive).
