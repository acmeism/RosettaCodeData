:- object(singleton).

    :- public(value/1).
    value(Value) :-
        state(Value).

    :- public(set_value/1).
    set_value(Value) :-
        retract(state(_)),
        assertz(state(Value)).

    :- private(state/1).
    :- dynamic(state/1).
    state(0).

:- end_object.
