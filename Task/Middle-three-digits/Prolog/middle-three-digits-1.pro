middle_3_digits(Number, [D1,D2,D3]) :-
    verify_middle_3_able(Number, Digits),
    append(FrontDigits, [D1,D2,D3| BackDigits], Digits),
    same_length(FrontDigits, BackDigits).

verify_middle_3_able(Number, Digits) :-
    must_be(number, Number),
    AbsNumber is abs(Number),
    number_chars(AbsNumber, Digits),
    length(Digits, NumDigits),
    ( 3 > NumDigits         ->  domain_error('at least 3 digits',    Number)
    ; 0 is NumDigits mod 2  ->  domain_error('odd number of digits', Number)
    ; true
    ).
