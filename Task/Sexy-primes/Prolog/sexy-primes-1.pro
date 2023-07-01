sexy_prime_group(1, N, _, [N]):-
    is_prime(N),
    !.
sexy_prime_group(Size, N, Limit, [N|Group]):-
    is_prime(N),
    N1 is N + 6,
    N1 =< Limit,
    S1 is Size - 1,
    sexy_prime_group(S1, N1, Limit, Group).

print_sexy_prime_groups(Size, Limit):-
    findall(G, (is_prime(P), P =< Limit, sexy_prime_group(Size, P, Limit, G)), Groups),
    length(Groups, Len),
    writef('Number of groups of size %t is %t\n', [Size, Len]),
    last_n(Groups, 5, Len, Last, Last_len),
    writef('Last %t groups of size %t: %t\n\n', [Last_len, Size, Last]).

last_n([], _, L, [], L):-!.
last_n([_|List], Max, Length, Last, Last_len):-
    Max < Length,
    !,
    Len1 is Length - 1,
    last_n(List, Max, Len1, Last, Last_len).
last_n([E|List], Max, Length, [E|Last], Last_len):-
    last_n(List, Max, Length, Last, Last_len).

unsexy(P):-
    P1 is P + 6,
    \+is_prime(P1),
    P2 is P - 6,
    \+is_prime(P2).

main(Limit):-
    Max is Limit + 6,
    find_prime_numbers(Max),
    print_sexy_prime_groups(2, Limit),
    print_sexy_prime_groups(3, Limit),
    print_sexy_prime_groups(4, Limit),
    print_sexy_prime_groups(5, Limit),
    findall(P, (is_prime(P), P =< Limit, unsexy(P)), Unsexy),
    length(Unsexy, Count),
    writef('Number of unsexy primes is %t\n', [Count]),
    last_n(Unsexy, 10, Count, Last10, _),
    writef('Last 10 unsexy primes: %t', [Last10]).

main:-
    main(1000035).
