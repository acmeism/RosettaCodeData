van_eck_init(v(0, 0, _assoc)):-
    empty_assoc(_assoc).

van_eck_next(v(Index, Last_term, Last_pos), v(Index1, Next_term, Last_pos1)):-
    (get_assoc(Last_term, Last_pos, V) ->
        Next_term is Index - V
        ;
        Next_term = 0
    ),
    Index1 is Index + 1,
    put_assoc(Last_term, Last_pos, Index, Last_pos1).

van_eck_sequence(N, Seq):-
    van_eck_init(V),
    van_eck_sequence(N, V, Seq).

van_eck_sequence(0, _, []):-!.
van_eck_sequence(N, V, [Term|Rest]):-
    V = v(_, Term, _),
    van_eck_next(V, V1),
    N1 is N - 1,
    van_eck_sequence(N1, V1, Rest).

write_list(From, To, _, _):-
    To < From,
    !.
write_list(_, _, _, []):-!.
write_list(From, To, N, [_|Rest]):-
    From > N,
    !,
    N1 is N + 1,
    write_list(From, To, N1, Rest).
write_list(From, To, N, [E|Rest]):-
    writef('%t ', [E]),
    F1 is From + 1,
    N1 is N + 1,
    write_list(F1, To, N1, Rest).

write_list(From, To, List):-
    write_list(From, To, 1, List),
    nl.

main:-
    van_eck_sequence(1000, Seq),
    writeln('First 10 terms of the Van Eck sequence:'),
    write_list(1, 10, Seq),
    writeln('Terms 991 to 1000 of the Van Eck sequence:'),
    write_list(991, 1000, Seq).
