:- object(catalan, implements(seqp)).

    :- private(catalan/2).
    :- dynamic(catalan/2).

    % Public interface.

    init :- retractall(catalan(_,_)).   % flush any memoized results

    nth(N, V) :- \+ catalan(N, V), catalan_(N, V), !.   % generate iff it's not been memoized
    nth(N, V) :- catalan(N, V), !.                      % otherwise use the memoized version

    to_nth(N, L) :-
        integer::sequence(0, N, S), % generate a list of 0 to N
        meta::map(nth, S, L).       % map the nth/2 predicate to the list for all Catalan numbers up to N

    % Local helper predicates.

    catalan_(N, V) :-
        N > 0,                              % calculate
        N1 is N - 1,
        N2 is N + 1,
        catalan_(N1, V1),                   % via a recursive call
        V is V1 * 2 * (2 * N - 1) // N2,
        assertz(catalan(N, V)).             % and memoize the result
    catalan_(0, 1).

:- end_object.
