:- object(substring).

    :- public(test/5).

    test(String, N, M, Character, Substring) :-
        sub_atom(String, N, M, _, Substring1),
        write(Substring1), nl,
        sub_atom(String, N, _, 0, Substring2),
        write(Substring2), nl,
        sub_atom(String, 0, _, 1, Substring3),
        write(Substring3), nl,
        % there can be multiple occurences of the character
        once(sub_atom(String, Before4, 1, _, Character)),
        sub_atom(String, Before4, M, _, Substring4),
        write(Substring4), nl,
        % there can be multiple occurences of the substring
        once(sub_atom(String, Before5, _, _, Substring)),
        sub_atom(String, Before5, M, _, Substring5),
        write(Substring5), nl.

:- end_object.
