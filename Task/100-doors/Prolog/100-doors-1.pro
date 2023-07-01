main :-
    forall(between(1,100,Door), ignore(display(Door))).

% show output if door is open after the 100th pass
display(Door) :-
    status(Door, 100, open),
    format("Door ~d is open~n", [Door]).

% true if Door has Status after Pass is done
status(Door, Pass, Status) :-
    Pass > 0,
    Remainder is Door mod Pass,
    toggle(Remainder, OldStatus, Status),
    OldPass is Pass - 1,
    status(Door, OldPass, OldStatus).
status(_Door, 0, closed).

toggle(Remainder, Status, Status) :-
    Remainder > 0.
toggle(0, open, closed).
toggle(0, closed, open).
