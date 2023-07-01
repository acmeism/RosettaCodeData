:- object(slow_print).

    :- threaded.

    :- public(start/0).

    :- private([slow_print_abc/0, slow_print_123/0]).
    :- synchronized([slow_print_abc/0, slow_print_123/0]).

    start :-
        % launch two threads, running never ending goals
        threaded((
            repeat_abc,
            repeat_123
        )).

    repeat_abc :-
        repeat, slow_print_abc, fail.

    repeat_123 :-
        repeat, slow_print_123, fail.

    slow_print_abc :-
        write(a), thread_sleep(0.2),
        write(b), thread_sleep(0.2),
        write(c), nl.

    slow_print_123 :-
        write(1), thread_sleep(0.2),
        write(2), thread_sleep(0.2),
        write(3), nl.

:- end_object.
