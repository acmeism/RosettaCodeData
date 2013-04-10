plus :-
    read_line_to_codes(user_input,X),
    atom_codes(A, X),
    atomic_list_concat(L, ' ', A),
    maplist(atom_number, L, LN),
    sumlist(LN, N),
    write(N).
