wheel235(L) :-
    W = [6, 4, 2, 4, 2, 4, 6, 2 | W],
    lazy_list(accumulate, 1/W, L).

accumulate(M/[A|As], N/As, N) :- N is M + A.

roll235wheel(Limit, A) :-
    wheel235(W),
    append(A, [N|_], W),
    N > Limit, !.	

prime235(N) :- % N is prime excepting multiples of 2, 3, 5.
    wheel235(W),
    wheel_prime(N, W).

wheel_prime(N, [D|_]) :- D*D > N, !.
wheel_prime(N, [D|Ds]) :- N mod D =\= 0, wheel_prime(N, Ds).

primes(Limit, [2, 3, 5 | Primes]) :-
    roll235wheel(Limit, Candidates),
    include(prime235, Candidates, Primes).
