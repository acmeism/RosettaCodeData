:- initialization(main).

% Simulate a play.
play(Switch, Won) :-
    % Random prize door
    random(1, 4, P),

    % Random contestant door
    random(1, 4, C),

    % Random reveal door, not prize or contestant door
    repeat,
    random(1, 4, R),
    R \= P,
    R \= C,
    !,

    % Final door
    (
        Switch, between(1, 3, F), F \= C, F \= R, !;
        \+ Switch, F = C
    ),

    % Check result.
    (F = P -> Won = true ; Won = false).

% Count wins.
win_count(0, _, Total, Total).

win_count(I, Switch, A, Total) :-
    I > 0,
    I1 is I - 1,
    play(Switch, Won),
    (Won, A1 is A + 1;
    \+ Won, A1 is A),
    win_count(I1, Switch, A1, Total).

main :-
    randomize,
    win_count(1000, true, 0, SwitchTotal),
    format('Switching wins ~d out of 1000.\n', [SwitchTotal]),
    win_count(1000, false, 0, StayTotal),
    format('Staying wins ~d out of 1000.\n', [StayTotal]).
