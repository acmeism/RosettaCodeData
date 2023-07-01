count_jewels(Stones, Jewels, N):-
    string_codes(Stones, Scodes),
    string_codes(Jewels, Jcodes),
    msort(Scodes, SScodes),
    sort(Jcodes, SJcodes),
    count_jewels(SScodes, SJcodes, N, 0).

count_jewels([], _, N, N):-!.
count_jewels(_, [], N, N):-!.
count_jewels([C|Stones], [C|Jewels], N, R):-
    !,
    R1 is R + 1,
    count_jewels(Stones, [C|Jewels], N, R1).
count_jewels([S|Stones], [J|Jewels], N, R):-
    J < S,
    !,
    count_jewels([S|Stones], Jewels, N, R).
count_jewels([_|Stones], Jewels, N, R):-
    count_jewels(Stones, Jewels, N, R).
