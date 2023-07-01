:- object(integers).

    :- public(show/0).

    show :-
        write('Binary      0b11110101101 = '), write(0b11110101101), nl,
        write('Octal       0o3655 =        '), write(0o3655), nl,
        write('Decimal     1965 =          '), write(1965), nl,
        write('Hexadecimal 0x7AD =         '), write(0x7AD), nl.

:- end_object.
