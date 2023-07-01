:- object(catalan_test).

    :- public(run/0).

    run :-
        % put the object into a known initial state
        catalan::init,

        % first 15 Catalan numbers, record duration.
        time_operation(catalan::to_nth(15, C1), D1),

        % first 15 Catalan numbers again, twice, recording duration.
        time_operation(catalan::to_nth(15, C2), D2),
        time_operation(catalan::to_nth(15, C3), D3),

        % reset the object again
        catalan::init,

        % first 15 Catalan numbers, record duration.
        time_operation(catalan::to_nth(15, C4), D4),

        % ensure the results were the same each time
        C1 = C2, C2 = C3, C3 = C4,

        % write the results and durations of each run
        write(C1), write(' '), write(D1), nl,
        write(C2), write(' '), write(D2), nl,
        write(C3), write(' '), write(D3), nl,
        write(C4), write(' '), write(D4), nl.
        % visual inspection should show all results the same
        % first and final durations should be much larger

    :- meta_predicate(time_operation(0, *)).

    time_operation(Goal, Duration) :-
        time::cpu_time(Before),
        call(Goal),
        time::cpu_time(After),
        Duration is After - Before.

:- end_object.
