:- object(team).

    :- threaded.

    :- public(start/0).
    start :-
        threaded((
            reader,
            writer(0)
        )).

    reader :-
        open('input.txt', read, Stream),
        repeat,
            read_term(Stream, Term, []),
            threaded_notify(term(Term)),
        Term == end_of_file,
        !,
        close(Stream),
        threaded_wait(lines(Lines)),
        write('Number of lines: '), write(Lines), nl.

    writer(N0) :-
        threaded_wait(term(Term)),
        (   Term == end_of_file ->
            threaded_notify(lines(N0))
        ;   N is N0 + 1,
            write(Term), nl,
            writer(N)
        ).

:- end_object.
