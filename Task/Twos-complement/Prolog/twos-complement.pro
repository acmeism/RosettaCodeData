d(1234567).

b([-D, -D + 1, -2, -1, 0, 1, 2, D - 2, D - 1]) :-
    d(D).

print_array([]).
print_array([H|T]) :-
    NegH is -H,
    format('~d -> ~d~n', [H, NegH]),
    print_array(T).

main :-
    b(B),
    print_array(B).
