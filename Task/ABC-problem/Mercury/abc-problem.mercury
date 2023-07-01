:- module abc.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module list, string, char.

:- type block == {char, char}.

:- pred take(char, list(block), list(block)).
:- mode take(in, in, out) is nondet.
take(C, !Blocks) :-
    list.delete(!.Blocks, {A, B}, !:Blocks),
    ( A = C ; B = C ).

:- pred can_make_word(list(char)::in, list(block)::in) is semidet.
can_make_word([], _).
can_make_word([C|Cs], !.Blocks) :-
    take(C, !Blocks),
    can_make_word(Cs, !.Blocks).

main(!IO) :-
    Blocks = [
        {'B', 'O'}, {'X', 'K'}, {'D', 'Q'}, {'C', 'P'}, {'N', 'A'},
        {'G', 'T'}, {'R', 'E'}, {'T', 'G'}, {'Q', 'D'}, {'F', 'S'},
        {'J', 'W'}, {'H', 'U'}, {'V', 'I'}, {'A', 'N'}, {'O', 'B'},
        {'E', 'R'}, {'F', 'S'}, {'L', 'Y'}, {'P', 'C'}, {'Z', 'M'}
    ],
    Words = ["A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE"],
    foldl((pred(W::in, !.IO::di, !:IO::uo) is det :-
            P = can_make_word(to_char_list(W), Blocks),
            io.format("can_make_word(""%s"") :- %s.\n",
                [s(W), s(if P then "true" else "fail")], !IO)),
        Words, !IO).
