:- object(sleep).

    :- public(how_long/1).

    how_long(Seconds) :-
        write('Sleeping ...'), nl,
        thread_sleep(Seconds),
        write('... awake!'), nl.

:- end_object.
