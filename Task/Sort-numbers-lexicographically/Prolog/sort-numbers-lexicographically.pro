lexicographical_sort(Numbers, Sorted_numbers):-
    number_strings(Numbers, Strings),
    sort(Strings, Sorted_strings),
    number_strings(Sorted_numbers, Sorted_strings).

number_strings([], []):-!.
number_strings([Number|Numbers], [String|Strings]):-
    number_string(Number, String),
    number_strings(Numbers, Strings).

number_list(From, To, []):-
    From > To,
    !.
number_list(From, To, [From|Rest]):-
    Next is From + 1,
    number_list(Next, To, Rest).

lex_sorted_number_list(Number, List):-
    (Number < 1 ->
        number_list(Number, 1, Numbers)
        ;
        number_list(1, Number, Numbers)
    ),
    lexicographical_sort(Numbers, List).

test(Number):-
    lex_sorted_number_list(Number, List),
    writef('%w: %w\n', [Number, List]).

main:-
    test(0),
    test(5),
    test(13),
    test(21),
    test(-22).
