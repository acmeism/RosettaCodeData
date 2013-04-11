:- object(metaclass,
    instantiates(metaclass)).

    :- public(new/2).
    new(Instance, Value) :-
        self(Class),
        create_object(Instance, [instantiates(Class)], [], [state(Value)]).

:- end_object.

:- object(class,
    instantiates(metaclass)).

    :- public(method/1).
    method(Value) :-
        ::state(Value).

    :- private(state/1).

:- end_object.
