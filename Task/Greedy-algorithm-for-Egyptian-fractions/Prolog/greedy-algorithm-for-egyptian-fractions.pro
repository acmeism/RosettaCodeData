count_digits(Number, Count):-
    atom_number(A, Number),
    atom_length(A, Count).

integer_to_atom(Number, Atom):-
    atom_number(A, Number),
    atom_length(A, Count),
    (Count =< 20 ->
        Atom = A
        ;
        sub_atom(A, 0, 10, _, A1),
        P is Count - 10,
        sub_atom(A, P, 10, _, A2),
        atom_concat(A1, '...', A3),
        atom_concat(A3, A2, Atom)
    ).

egyptian(0, _, []):- !.
egyptian(X, Y, [Z|E]):-
    Z is (Y + X - 1)//X,
    X1 is -Y mod X,
    Y1 is Y * Z,
    egyptian(X1, Y1, E).

print_egyptian([]):- !.
print_egyptian([N|List]):-
    integer_to_atom(N, A),
    write(1/A),
    (List = [] -> true; write(' + ')),
    print_egyptian(List).

print_egyptian(X, Y):-
    writef('Egyptian fraction for %t/%t: ', [X, Y]),
    (X > Y ->
        N is X//Y,
        writef('[%t] ', [N]),
        X1 is X mod Y
        ;
        X1 = X
    ),
    egyptian(X1, Y, E),
    print_egyptian(E),
    nl.

max_terms_and_denominator1(D, Max_terms, Max_denom, Max_terms1, Max_denom1):-
    max_terms_and_denominator1(D, 1, Max_terms, Max_denom, Max_terms1, Max_denom1).

max_terms_and_denominator1(D, D, Max_terms, Max_denom, Max_terms, Max_denom):- !.
max_terms_and_denominator1(D, N, Max_terms, Max_denom, Max_terms1, Max_denom1):-
    Max_terms1 = f(_, _, _, Len1),
    Max_denom1 = f(_, _, _, Max1),
    egyptian(N, D, E),
    length(E, Len),
    last(E, Max),
    (Len > Len1 ->
        Max_terms2 = f(N, D, E, Len)
        ;
        Max_terms2 = Max_terms1
    ),
    (Max > Max1 ->
        Max_denom2 = f(N, D, E, Max)
        ;
        Max_denom2 = Max_denom1
    ),
    N1 is N + 1,
    max_terms_and_denominator1(D, N1, Max_terms, Max_denom, Max_terms2, Max_denom2).

max_terms_and_denominator(N, Max_terms, Max_denom):-
    max_terms_and_denominator(N, 1, Max_terms, Max_denom, f(0, 0, [], 0),
                              f(0, 0, [], 0)).

max_terms_and_denominator(N, N, Max_terms, Max_denom, Max_terms, Max_denom):-!.
max_terms_and_denominator(N, N1, Max_terms, Max_denom, Max_terms1, Max_denom1):-
    max_terms_and_denominator1(N1, Max_terms2, Max_denom2, Max_terms1, Max_denom1),
    N2 is N1 + 1,
    max_terms_and_denominator(N, N2, Max_terms, Max_denom, Max_terms2, Max_denom2).

show_max_terms_and_denominator(N):-
    writef('Proper fractions with most terms and largest denominator, limit = %t:\n', [N]),
    max_terms_and_denominator(N, f(N_max_terms, D_max_terms, E_max_terms, Len),
                              f(N_max_denom, D_max_denom, E_max_denom, Max)),
    writef('Most terms (%t): %t/%t = ', [Len, N_max_terms, D_max_terms]),
    print_egyptian(E_max_terms),
    nl,
    count_digits(Max, Digits),
    writef('Largest denominator (%t digits): %t/%t = ', [Digits, N_max_denom, D_max_denom]),
    print_egyptian(E_max_denom),
    nl.

main:-
    print_egyptian(43, 48),
    print_egyptian(5, 121),
    print_egyptian(2014, 59),
    nl,
    show_max_terms_and_denominator(100),
    nl,
    show_max_terms_and_denominator(1000).
