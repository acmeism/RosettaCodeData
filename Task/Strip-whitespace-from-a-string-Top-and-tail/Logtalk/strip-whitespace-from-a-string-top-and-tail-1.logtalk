:- object(whitespace).

    :- public(trim/4).

    trim(String, TrimLeft, TrimRight, TrimBoth) :-
        trim_left(String, TrimLeft),
        trim_right(String, TrimRight),
        trim_right(TrimLeft, TrimBoth).

    trim_left(String, TrimLeft) :-
        atom_codes(String, Codes),
        trim(Codes, TrimCodes),
        atom_codes(TrimLeft, TrimCodes).

    trim_right(String, TrimRight) :-
        atom_codes(String, Codes),
        list::reverse(Codes, ReverseCodes),
        trim(ReverseCodes, ReverseTrimCodes),
        list::reverse(ReverseTrimCodes, TrimCodes),
        atom_codes(TrimRight, TrimCodes).

    trim([], []).
    trim([InCode| InCodes], OutCodes) :-
        (   InCode =< 32 ->
            trim(InCodes, OutCodes)
        ;   OutCodes = [InCode| InCodes]
        ).

:- end_object.
