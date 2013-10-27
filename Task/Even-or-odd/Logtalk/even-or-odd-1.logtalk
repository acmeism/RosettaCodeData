:- object(even_odd).

    :- public(test_mod/1).
    test_mod(I) :-
        (   I mod 2 =:= 0 ->
            write(even), nl
        ;   write(odd), nl
        ).

    :- public(test_bit/1).
    test_bit(I) :-
        (   I /\ 1 =:= 1 ->
            write(odd), nl
        ;   write(even), nl
        ).

:- end_object.
