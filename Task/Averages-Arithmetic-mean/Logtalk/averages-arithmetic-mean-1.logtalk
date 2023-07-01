:- object(averages).

    :- public(arithmetic/2).

    % fails for empty vectors
    arithmetic([X| Xs], Mean) :-
        sum_and_count([X| Xs], 0, Sum, 0, Count),
        Mean is Sum / Count.

    % use accumulators to make the predicate tail-recursive
    sum_and_count([], Sum, Sum, Count, Count).
    sum_and_count([X| Xs], Sum0, Sum, Count0, Count) :-
        Sum1 is Sum0 + X,
        Count1 is Count0 + 1,
        sum_and_count(Xs, Sum1, Sum, Count1, Count).

:- end_object.
