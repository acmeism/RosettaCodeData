primes(N, L) :- numlist(2, N, Xs),
	        sieve(Xs, L).

sieve([H|T], [H|X]) :- H2 is H + H,
                       filter(H, H2, T, R),
                       sieve(R, X).
sieve([], []).

filter(_, _, [], []).
filter(H, H2, [H1|T], R) :-
    (   H1 < H2 -> R = [H1|R1], filter(H, H2, T, R1)
    ;   H3 is H2 + H,
        (   H1 =:= H2  ->       filter(H, H3, T, R)
        ;                       filter(H, H3, [H1|T], R) ) ).
