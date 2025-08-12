:- initialization(main, main).

%!  next_number_in_chain(+Number0, -Number) is det.
next_number_in_chain(Number0, Number) :- next_number_in_chain_(Number0, 0, Number).

next_number_in_chain_(Number0, Number1, Number) :-
    divmod(Number0, 10, Div, Mod),
    Number2 is Number1 + Mod ^ 2,
    (   Div = 0
    ->  Number2 = Number
    ;   next_number_in_chain_(Div, Number2, Number)
    ).

%!  number_chain(+Number, -End) is det.
number_chain(Number0, End) :-
    (   Number0 =< 81 * 9
    ->  number_chain_(Number0, End)
    ;   next_number_in_chain(Number0, Number),
        number_chain(Number, End)
    ).

:- table number_chain_/2.
number_chain_(89, 89).
number_chain_( 1,  1).
number_chain_(Number0, End) :-
    next_number_in_chain(Number0, Number),
    number_chain_(Number, End).

%!  task(+Max, -Result) is det.
task(Max, Result) :-
    aggregate_all(count, ( between(1, Max, N), number_chain(N, 89) ), Result).

main([Input]) :-
    atom_number(Input, Number),
    time(task(Number, Result)),
    writeln(Result).
