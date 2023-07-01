:- object(checkpoint).

    :- threaded.

    :- public(run/3).
    :- mode(run(+integer,+integer,+float), one).
    :- info(run/3, [
        comment is 'Assemble items using a team of workers with a maximum time per item assembly.',
        arguments is ['Workers'-'Number of workers', 'Items'-'Number of items to assemble', 'Time'-'Maximum time in seconds to assemble one item']
    ]).

    :- public(run/0).
    :- mode(run, one).
    :- info(run/0, [
        comment is 'Assemble three items using a team of five workers with a maximum of 0.1 seconds per item assembly.'
    ]).

    :- uses(integer, [between/3]).
    :- uses(random,  [random/3]).

    run(Workers, Items, Time) :-
        % start the workers
        forall(
            between(1, Workers, Worker),
            threaded_ignore(worker(Worker, Items, Time))
        ),
        % assemble the items
        checkpoint_loop(Workers, Items).

    run :-
        % default values
        run(5, 3, 0.100).

    checkpoint_loop(_, 0) :-
        !,
        write('All assemblies done.'), nl.
    checkpoint_loop(Workers, Item) :-
        % wait for all threads to reach the checkpoint
        forall(
            between(1, Workers, Worker),
            threaded_wait(done(Worker, Item))
        ),
        write('Assembly of item '), write(Item), write(' done.'), nl,
        % signal the workers to procede to the next assembly
        NextItem is Item - 1,
        forall(
            between(1, Workers, Worker),
            threaded_notify(next(Worker, NextItem))
        ),
        checkpoint_loop(Workers, NextItem).

    worker(_, 0, _) :-
        !.
    worker(Worker, Item, Time) :-
        % the time necessary to assemble one item varies between 0.0 and Time seconds
        random(0.0, Time, AssemblyTime), thread_sleep(AssemblyTime),
        write('Worker '), write(Worker), write(' item '), write(Item), nl,
        % notify checkpoint that the worker have done his/her part of this item
        threaded_notify(done(Worker, Item)),
        % wait for green light to move to the next item
        NextItem is Item - 1,
        threaded_wait(next(Worker, NextItem)),
        worker(Worker, NextItem, Time).

:- end_object.
