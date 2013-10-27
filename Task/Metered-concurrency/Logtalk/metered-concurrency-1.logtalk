:- object(metered_concurrency).

    :- threaded.

    :- public(run/2).
    run(Workers, Max) :-
        % start the semaphore and the workers
        threaded_ignore(semaphore(Max, Max)),
        forall(
            integer::between(1, Workers, Worker),
            threaded_call(worker(Worker))
        ),
        % wait for the workers to finish
        forall(
            integer::between(1, Workers, Worker),
            threaded_exit(worker(Worker))
        ),
        % tell the semaphore thread to stop
        threaded_notify(worker(stop, _)).

    :- public(run/0).
    run :-
        % default values: 7 workers, 2 concurrent workers
        run(7, 2).

    semaphore(N, Max) :-
        threaded_wait(worker(Action, Worker)),
        (   Action == acquire, N > 0 ->
            M is N - 1,
            threaded_notify(semaphore(acquired, Worker)),
            semaphore(M, Max)
        ;   Action == release ->
            M is N + 1,
            threaded_notify(semaphore(released, Worker)),
            semaphore(M, Max)
        ;   Action == stop ->
            true
        ;   % Action == acquire, N =:= 0,
            threaded_wait(worker(release, OtherWorker)),
            threaded_notify(semaphore(released, OtherWorker)),
            threaded_notify(semaphore(acquired, Worker)),
            semaphore(N, Max)
        ).

    worker(Worker) :-
        % use a random setup time for the worker
        random::random(0.0, 2.0, Setup),
        thread_sleep(Setup),
        threaded_notify(worker(acquire, Worker)),
        threaded_wait(semaphore(acquired, Worker)),
        write('Worker '), write(Worker), write(' acquired semaphore\n'),
        thread_sleep(2),
        threaded_notify(worker(release, Worker)),
        write('Worker '), write(Worker), write(' releasing semaphore\n'),
        threaded_wait(semaphore(released, Worker)).

:- end_object.
