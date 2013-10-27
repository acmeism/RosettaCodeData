:- object(top_and_tail).

    :- public(test/1).
    test(String) :-
        sub_atom(String, 1, _, 0, MinusTop),
        write('String with first character cut: '), write(MinusTop), nl,
        sub_atom(String, 0, _, 1, MinusTail),
        write('String with last character cut: '), write(MinusTail), nl,
        sub_atom(String, 1, _, 1, MinusTopAndTail),
        write('String with first and last characters cut: '), write(MinusTopAndTail), nl.

:- end_object.
