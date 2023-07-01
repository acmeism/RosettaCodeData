bell(N, Bell):-
    bell(N, Bell, [], _).

bell(0, [[1]|T], T, [1]):-!.
bell(N, Bell, B, Row):-
    N1 is N - 1,
    bell(N1, Bell, [Row|B], Last),
    next_row(Row, Last).

next_row([Last|Bell], Bell1):-
    last(Bell1, Last),
    next_row1(Last, Bell, Bell1).

next_row1(_, [], []):-!.
next_row1(X, [Y|Rest], [B|Bell]):-
    Y is X + B,
    next_row1(Y, Rest, Bell).

print_bell_numbers(_, 0):-!.
print_bell_numbers([[Number|_]|Bell], N):-
    writef('%w\n', [Number]),
    N1 is N - 1,
    print_bell_numbers(Bell, N1).

print_bell_rows(_, 0):-!.
print_bell_rows([Row|Rows], N):-
    print_bell_row(Row),
    N1 is N - 1,
    print_bell_rows(Rows, N1).

print_bell_row([Number]):-
    !,
    writef('%w\n', [Number]).
print_bell_row([Number|Numbers]):-
    writef('%w ', [Number]),
    print_bell_row(Numbers).

main:-
    bell(49, Bell),
    writef('First 15 Bell numbers:\n'),
    print_bell_numbers(Bell, 15),
    last(Bell, [Number|_]),
    writef('\n50th Bell number: %w\n', [Number]),
    writef('\nFirst 10 rows of Bell triangle:\n'),
    print_bell_rows(Bell, 10).
