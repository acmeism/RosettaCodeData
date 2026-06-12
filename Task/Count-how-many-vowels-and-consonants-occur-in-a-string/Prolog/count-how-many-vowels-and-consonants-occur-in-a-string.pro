:- set_prolog_flag(double_quotes, codes).

key_is_vowel(Code - _) :- ord_memberchk(Code, "aeiou").

task(String) :-
    include(is_alpha, String, Alphas),
    maplist(to_lower, Alphas, Lower),
    msort(Lower, Sorted),
    clumped(Sorted, Clumped),
    partition(key_is_vowel, Clumped, Vowels, Consonants),
    pairs_values(Vowels, VowelCounts),
    sum_list(VowelCounts, TotalVowels),
    length(Vowels, DistinctVowels),
    pairs_values(Consonants, ConsonantCounts),
    sum_list(ConsonantCounts, TotalConsonants),
    length(Consonants, DistinctConsonants),
    format("String: ~s~n    Vowels: ~d (distinct ~d)~n    Consonants: ~d (distinct ~d)~n",
        [String, TotalVowels, DistinctVowels, TotalConsonants, DistinctConsonants]).

:- initialization(main, main).
main([Arg]) :- atom_codes(Arg, Codes), task(Codes).
