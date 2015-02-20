:- object(spliting).

    :- public(convert/2).
    :- mode(convert(+atom, -atom), one).

    convert(StringIn, StringOut) :-
        atom_chars(StringIn, CharactersIn),
        phrase(split(',', Tokens), CharactersIn),
        phrase(split('.', Tokens), CharactersOut),
        atom_chars(StringOut, CharactersOut).

    split(Separator, [t([Character| Characters])| Tokens]) -->
        [Character], {Character \== Separator}, split(Separator, [t(Characters)| Tokens]).
    split(Separator, [t([])| Tokens]) -->
        [Separator], split(Separator, Tokens).
    split(_, [t([])]) -->
        [].
    % the look-ahead in the next rule prevents adding a spurious separator at the end
    split(_, []), [Character] -->
        [Character].

:- end_object.
