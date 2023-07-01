:- object(buckets).

    :- threaded.

    :- public([start/0, start/4]).

    % bucket representation
    :- private(bucket_/2).
    :- dynamic(bucket_/2).

    % use the same mutex for all the predicates that access the buckets
    :- private([bucket/2, buckets/1, transfer/3]).
    :- synchronized([bucket/2, buckets/1, transfer/3]).

    start :-
        % by default, create ten buckets with initial random integer values
        % in the interval [0, 10[ and print their contents ten times
        start(10, 0, 10, 10).

    start(N, Min, Max, Samples) :-
        % create the buckets with random values in the
        % interval [Min, Max[ and return their sum
        create_buckets(N, Min, Max, Sum),
        write('Sum of all bucket values: '), write(Sum), nl, nl,
        % use competitive or-parallelism for the three loops such that
        % the computations terminate when the display loop terminates
        threaded((
                display_loop(Samples)
            ;   match_loop(N)
            ;   redistribute_loop(N)
        )).

    create_buckets(N, Min, Max, Sum) :-
        % remove all exisiting buckets
        retractall(bucket_(_,_)),
        % create the new buckets
        create_buckets(N, Min, Max, 0, Sum).

    create_buckets(0, _, _, Sum, Sum) :-
        !.
    create_buckets(N, Min, Max, Sum0, Sum) :-
        random::random(Min, Max, Value),
        asserta(bucket_(N,Value)),
        M is N - 1,
        Sum1 is Sum0 + Value,
        create_buckets(M, Min, Max, Sum1, Sum).

    bucket(Bucket, Value) :-
        bucket_(Bucket, Value).

    buckets(Values) :-
        findall(Value, bucket_(_, Value), Values).

    transfer(Origin, _, Origin) :-
        !.
    transfer(Origin, Delta, Destin) :-
        retract(bucket_(Origin, OriginValue)),
        retract(bucket_(Destin, DestinValue)),
        % the buckets may have changed between the access to its
        % values and the calling of this transfer predicate; thus,
        % we must ensure that we're transfering a legal amount
        Amount is min(Delta, OriginValue),
        NewOriginValue is OriginValue - Amount,
        NewDestinValue is DestinValue + Amount,
        assertz(bucket_(Origin, NewOriginValue)),
        assertz(bucket_(Destin, NewDestinValue)).

    match_loop(N) :-
        % randomly select two buckets
        M is N + 1,
        random::random(1, M, Bucket1),
        random::random(1, M, Bucket2),
        % access their contents
        bucket(Bucket1, Value1),
        bucket(Bucket2, Value2),
        % make their new values approximately equal
        Delta is truncate(abs(Value1 - Value2)/2),
        (   Value1 > Value2 ->
            transfer(Bucket1, Delta, Bucket2)
        ;   Value1 < Value2 ->
            transfer(Bucket2, Delta, Bucket1)
        ;   true
        ),
        match_loop(N).

    redistribute_loop(N) :-
        % randomly select two buckets
        M is N + 1,
        random::random(1, M, FromBucket),
        random::random(1, M, ToBucket),
        % access bucket from where we transfer
        bucket(FromBucket, Current),
        Limit is Current + 1,
        random::random(0, Limit, Delta),
        transfer(FromBucket, Delta, ToBucket),
        redistribute_loop(N).

    display_loop(0) :-
        !.
    display_loop(N) :-
        buckets(Values),
        write(Values), nl,
        thread_sleep(2),
        M is N - 1,
        display_loop(M).

:- end_object.
