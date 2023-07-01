:- object(user_input).

    :- public(test/0).
    test :-
        repeat,
            write('Enter an integer: '),
            read(Integer),
        integer(Integer),
        !,
        repeat,
            write('Enter an atom: '),
            read(Atom),
        atom(Atom),
        !.

:- end_object.
