checkpair(1, 2).
checkpair(R, K) :-
    checkpair(R0, K0),
    R is 10*R0 + 1,
    K is K0 + 1.

deceptive(K) :-
    checkpair(R, K),
    \+ prime(K),
    divmod(R, K, _, 0).

task(K, Ns) :-
    lazy_findall(N, deceptive(N), Ds),
    length(Ns, K),
    prefix(Ns, Ds).

% check if a number is prime
%
wheel235(L) :-
   W = [4, 2, 4, 2, 4, 6, 2, 6 | W],
   L = [1, 2, 2 | W].

prime(N) :-
   N >= 2,
   wheel235(W),
   prime(N, 2, W).

prime(N, D, _) :- D*D > N, !.
prime(N, D, [A|As]) :-
    N mod D =\= 0,
    D2 is D + A, prime(N, D2, As).
