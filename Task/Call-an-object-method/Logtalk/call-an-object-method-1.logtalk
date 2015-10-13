% avoid infinite metaclass regression by
% making the metaclass an instance of itself
:- object(metaclass,
    instantiates(metaclass)).

    :- public(me/1).
    me(Me) :-
        self(Me).

:- end_object.
