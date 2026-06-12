:- use_module(library(pairs)).

:- meta_predicate schwartzian_transform(2, +, -).
schwartzian_transform(KeyGoal, List, SortedList) :-
    map_list_to_pairs(KeyGoal, List, Pairs),
    keysort(Pairs, SortedPairs),
    pairs_values(SortedPairs, SortedList).
