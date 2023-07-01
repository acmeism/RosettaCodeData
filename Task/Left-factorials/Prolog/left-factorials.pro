leftfact(N):-
    leftfact(N, 0, 0, 1).

leftfact(N, N, _, _):-
    !.
leftfact(N, M, L, F):-
    ((M =< 10 ; (M =< 110, 0 is M mod 10)) ->
        writef("!%w = %w\n", [M, L])
        ;
        (0 is M mod 1000 ->
            number_string(L, S),
            string_length(S, Len),
            writef("length of !%w is %w\n", [M, Len])
            ;
            true)),
    L1 is L + F,
    M1 is M + 1,
    F1 is F * M1,
    leftfact(N, M1, L1, F1).

main:-
    leftfact(10001).
