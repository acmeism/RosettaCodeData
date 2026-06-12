cube(X, XCubed) :- XCubed is X ^ 3.

first_n_cubes(N, Cubes) :-
    Max is N - 1,
    numlist(0, Max, Nums),
    maplist(cube, Nums, Cubes).

print_formatted(Width, Height, Numbers) :-
    FormatNumber = "~|~` t~d~8+",
    length(FormatRow0, Width),
    maplist(=(FormatNumber), FormatRow0),
    atomics_to_string(FormatRow0, FormatRow1),
    string_concat(FormatRow1, "~n", FormatRow),
    length(FormatString0, Height),
    maplist(=(FormatRow), FormatString0),
    atomics_to_string(FormatString0, FormatString),
    format(FormatString, Numbers).

:-  first_n_cubes(50, [Cube | Cubes]),
    scanl(plus, Cubes, Cube, CumulativeSums),
    print_formatted(10, 5, CumulativeSums).
