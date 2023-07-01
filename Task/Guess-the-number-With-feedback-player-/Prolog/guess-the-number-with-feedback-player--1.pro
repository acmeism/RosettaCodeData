min(1). max(10).

pick_number(Min, Max) :-
    min(Min), max(Max),
    format('Pick a number between ~d and ~d, and I will guess it...~nReady? (Enter anything when ready):', [Min, Max]),
    read(_).

guess_number(Min, Max) :-
    Guess is (Min + Max) // 2,
    format('I guess ~d...~nAm I correct (c), too low (l), or too high (h)? ', [Guess]),
    repeat,
        read(Score),
        ( Score = l -> NewMin is Guess + 1, guess_number(NewMin, Max)
        ; Score = h -> NewMax is Guess - 1, guess_number(Min, NewMax)
        ; Score = c -> writeln('I am correct!')
        ; writeln('Invalid input'),
          false
        ).

play :-
    pick_number(Min, Max),
    guess_number(Min, Max).
