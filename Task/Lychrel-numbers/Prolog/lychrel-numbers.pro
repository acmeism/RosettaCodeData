reverse_number(Number, Rev):-
    reverse_number(Number, 0, Rev).

reverse_number(0, Rev, Rev):-!.
reverse_number(N, R, Rev):-
    R1 is R * 10 + N mod 10,
    N1 is N // 10,
    reverse_number(N1, R1, Rev).

lychrel(N, M, _, [], [], []):-
    M > N,
    !.
lychrel(N, M, Cache, Seeds, Related, Palindromes):-
    reverse_number(M, R),
    lychrel_sequence(M, 0, M, R, Cache, Sequence, Result),
    update_cache(Cache, Sequence, Result, Cache1),
    M1 is M + 1,
    (Result == 0 ->
        S = Seeds, Rel = Related, P = Palindromes
        ;
        (R == M ->
            Palindromes = [M|P]
            ;
            Palindromes = P),
        (Result == M ->
            Seeds = [M|S], Related = Rel
            ;
            Seeds = S, Related = [M|Rel])),
    lychrel(N, M1, Cache1, S, Rel, P).

update_cache(Cache, [], _, Cache):-!.
update_cache(Cache, [S|Seq], Result, Cache2):-
    put_assoc(S, Cache, Result, Cache1),
    update_cache(Cache1, Seq, Result, Cache2).

lychrel_sequence(N, 500, _, _, _, [], N):-!.
lychrel_sequence(N, I, Sum, Rev, Cache, [Sum1|Sequence], Result):-
    I1 is I + 1,
    Sum1 is Sum + Rev,
    reverse_number(Sum1, Rev1),
    (((Rev1 == Sum1, Result = 0) ; get_assoc(Sum1, Cache, Result)) ->
        Sequence = []
        ;
        lychrel_sequence(N, I1, Sum1, Rev1, Cache, Sequence, Result)).

lychrel(N):-
    empty_assoc(Cache),
    lychrel(N, 1, Cache, Seeds, Related, Palindromes),
    length(Seeds, Num_seeds),
    length(Related, Num_related),
    writef('number of seeds: %w\n', [Num_seeds]),
    writef('seeds: %w\n', [Seeds]),
    writef('number of related: %w\n', [Num_related]),
    writef('palindromes: %w\n', [Palindromes]).

main:-
    lychrel(10000).
