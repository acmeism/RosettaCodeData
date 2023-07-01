main :-
    play_guess_number.


/* Parameteres */

low(1).
high(10).


/* Basic Game Logic */

play_guess_number :-
    low(Low),
    high(High),
    random(Low, High, N),
    tell_range(Low, High),
    repeat,                         % roughly, "repeat ... (until) Guess == N "
        ask_for_guess(Guess),
        give_feedback(N, Guess),
    Guess == N.

/* IO Stuff */

tell_range(Low, High) :-
    format('Guess an integer between ~d and ~d.~n', [Low,High]).

ask_for_guess(Guess) :-
    format('Guess the number: '),
    read(Guess).

give_feedback(N, Guess) :-
    ( \+integer(Guess) -> writeln('Invalid input.')
    ; Guess < N        -> writeln('Your guess is too low.')
    ; Guess > N        -> writeln('Your guess is too high.')
    ; Guess =:= N      -> writeln("Correct!")
    ).
