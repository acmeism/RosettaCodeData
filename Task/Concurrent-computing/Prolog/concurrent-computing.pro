main :-
    thread_create(say("Enjoy"),A,[]),
    thread_create(say("Rosetta"),B,[]),
    thread_create(say("Code"),C,[]),
    thread_join(A,_),
    thread_join(B,_),
    thread_join(C,_).

say(Message) :-
    Delay is random_float,
    sleep(Delay),
    writeln(Message).
