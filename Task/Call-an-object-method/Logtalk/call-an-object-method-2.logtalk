:- object(class,
    instantiates(metaclass)).

    :- public(my_class/1).
    my_class(Class) :-
        self(Self),
        instantiates_class(Self, Class).

:- end_object.
