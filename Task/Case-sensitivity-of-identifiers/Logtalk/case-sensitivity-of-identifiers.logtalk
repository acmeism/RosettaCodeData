:- object(three_dogs_or_one).

    :- public(test/0).

    test :-
        fill_dogs(DOG, Dog, DoG),
        write_message(DOG, Dog, DoG).

    % Note: this predicate would actually fail if variables weren't case sensitive...
    fill_dogs('Benjamin', 'Samba', 'Bernie').

    % Note: ...as a result there is no way for this clause to ever succeed.
    write_message(A, A, A) :-
       format('There is one dog named ~w.~n', [A]).

    write_message(A, B, C) :-
       A \= B, B \= C, A \= C,
       format('There are three dogs named ~w, ~w, and ~w.~n', [A, B, C]).

:- end_object.
