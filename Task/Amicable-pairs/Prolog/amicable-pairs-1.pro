divisor(N, Divisor) :-
    UpperBound is round(sqrt(N)),
    between(1, UpperBound, D),
    0 is N mod D,
    (
        Divisor = D
    ;
        LargerDivisor is N/D,
        LargerDivisor =\= D,
        Divisor = LargerDivisor
    ).

proper_divisor(N, D) :-
    divisor(N, D),
    D =\= N.

assoc_num_divsSum_in_range(Low, High, Assoc) :-
    findall( Num-DivSum,
             ( between(Low, High, Num),
               aggregate_all( sum(D),
                              proper_divisor(Num, D),
                              DivSum )),
             Pairs ),
    list_to_assoc(Pairs, Assoc).

get_amicable_pair(Assoc, M-N) :-
    gen_assoc(M, Assoc, N),
    M < N,
    get_assoc(N, Assoc, M).

amicable_pairs_under_20000(Pairs) :-
    assoc_num_divsSum_in_range(1,20000, Assoc),
    findall(P, get_amicable_pair(Assoc, P), Pairs).
