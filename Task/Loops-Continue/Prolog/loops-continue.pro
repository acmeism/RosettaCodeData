:- initialization(main).

print_list(Min, Max) :-
    Min < Max,
    write(Min),
    Min1 is Min + 1,
    (
        Min mod 5 =:= 0
        -> nl
        ; write(',')
    ),
    print_list(Min1, Max).

print_list(Max, Max) :-
    write(Max),
    nl.

main :-
    print_list(1, 10).
