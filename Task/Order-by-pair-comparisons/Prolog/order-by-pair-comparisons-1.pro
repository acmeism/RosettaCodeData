ask_sort(List, Sorted) :- predsort(ask, List, Sorted).

ask(Cmp, Left, Right) :-
    format("Comparing ~w with ~w:   ", [Left, Right]),
    get_single_char(Cmp0),
    char_code(Cmp1, Cmp0),
    (   memberchk(Cmp1, [<, =, >])
    ->  Cmp = Cmp1,
        writeln(Cmp1)
    ;   format("Please answer <, = or >."),
        ask(Cmp, Left, Right)
    ).
