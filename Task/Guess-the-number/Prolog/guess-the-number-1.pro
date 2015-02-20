main :-
    random_between(1, 10, N),
    repeat,
    prompt1('Guess the number: '),
    read(N),
    writeln('Well guessed!'),
    !.
