:- object(singly_linked_list).

    :- public(show/0).

    show :-
        traverse([1,2,3]).

    traverse([]).
    traverse([Head| Tail]) :-
        write(Head), nl,
        traverse(Tail).

:- end_object.
