:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).

%!  string_words(+String, -Words) is det.
%!  string_words(-String, +Words) is det.
%   Relates a string to the list of space-separated words in that string.
string_words(String, Words) :-
    once(phrase(sequence(nonblanks, " ", Words), String)).

phrase_reversals(String) :-
    reverse(String, Reversed),
    string_words(String, Words),
    maplist(reverse, Words, ReversedWords),
    string_words(ReversedWordsString, ReversedWords),
    reverse(Words, ReversedPhraseWords),
    string_words(ReversedPhrase, ReversedPhraseWords),
    format("~s~n~s~n~s~n~s~n", [String, Reversed, ReversedWordsString, ReversedPhrase]).

?- phrase_reversals("rosetta code phrase reversal").
