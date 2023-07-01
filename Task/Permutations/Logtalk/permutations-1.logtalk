:- object(list).

    :- public(permutation/2).

    permutation(List, Permutation) :-
        same_length(List, Permutation),
        permutation2(List, Permutation).

    permutation2([], []).
    permutation2(List, [Head| Tail]) :-
        select(Head, List, Remaining),
        permutation2(Remaining, Tail).

    same_length([], []).
    same_length([_| Tail1], [_| Tail2]) :-
        same_length(Tail1, Tail2).

    select(Head, [Head| Tail], Tail).
    select(Head, [Head2| Tail], [Head2| Tail2]) :-
        select(Head, Tail, Tail2).

:- end_object.
