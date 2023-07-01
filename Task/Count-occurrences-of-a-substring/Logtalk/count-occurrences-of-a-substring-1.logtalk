:- object(counting).

    :- public(count/3).

    count(String, SubString, Count) :-
        count(String, SubString, 0, Count).

    count(String, SubString, Count0, Count) :-
        (   sub_atom(String, Before, Length, After, SubString) ->
            Count1 is Count0 + 1,
            Start is Before + Length,
            sub_atom(String, Start, After, 0, Rest),
            count(Rest, SubString, Count1, Count)
        ;   Count is Count0
        ).

:- end_object.
