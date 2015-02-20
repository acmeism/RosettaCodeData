:- object(value_capture).

    :- public(show/0).
    show :-
        integer::sequence(1, 10, List),
        meta::map(create_closure, List, Closures),
        meta::map(call_closure, List, Closures).

    create_closure(Index, [Double]>>(Double is Index*Index)).

    call_closure(Index, Closure) :-
        call(Closure, Result),
        write('Closure '), write(Index), write(' : '), write(Result), nl.

:- end_object.
