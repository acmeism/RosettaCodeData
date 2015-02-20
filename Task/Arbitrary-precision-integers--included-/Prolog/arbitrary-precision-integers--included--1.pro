task(Length) :-
    N is 5^4^3^2,

    number_codes(N, Codes),
    append(`62060698786608744707`, _,  Codes),
    append(_, `92256259918212890625`, Codes),

    length(Codes, Length).
