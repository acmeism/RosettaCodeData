primes([2|PS]):-
    freeze(PS, (primes(BPS), count(3, 1, NS), sieve(NS, BPS, 4, PS))).

sieve([N|NS], BPS, Q, PS):-
    N < Q -> PS = [N|PS2], freeze(PS2, sieve(NS, BPS, Q, PS2))
    ;  BPS = [BP,BP2|BPS2], Q2 is BP2*BP2, count(Q, BP, MS),
       remove(MS, NS, R), sieve(R, [BP2|BPS2], Q2, PS).
