% table of nth prime values (up to 100,000)

nthprime(    10, 29).
nthprime(   100, 541).
nthprime(  1000, 7919).
nthprime( 10000, 104729).
nthprime(100000, 1299709).

conspiracy(M) :-
    N is 10**M,
    nthprime(N, P),
    sieve(P, Ps),
    tally(Ps, Counts),
    sort(Counts, Sorted),
    show(Sorted).

show(Results) :-
    forall(
        member(tr(D1, D2, Count), Results),
        format("~d -> ~d: ~d~n", [D1, D2, Count])).


% count results

tally(L, R) :- tally(L, [], R).
tally([_], T, T) :- !.
tally([A|As], T0, R) :-
    [B|_] = As,
    Da is A mod 10, Db is B mod 10,
    count(Da, Db, T0, T1),
    tally(As, T1, R).

count(D1, D2, [], [tr(D1, D2, 1)]) :- !.
count(D1, D2, [tr(D1, D2, N)|Ts], [tr(D1, D2, Sn)|Ts]) :- succ(N, Sn), !.
count(D1, D2, [T|Ts], [T|Us]) :- count(D1, D2, Ts, Us).


% implement a prime sieve

sieve(Limit, Ps) :-
    numlist(2, Limit, Ns),
    sieve(Limit, Ns, Ps).

sieve(Limit, W, W) :- W = [P|_], P*P > Limit, !.
sieve(Limit, [P|Xs], [P|Ys]) :-
    Q is P*P,
    remove_multiples(P, Q, Xs, R),
    sieve(Limit, R, Ys).

remove_multiples(_, _, [], []) :- !.
remove_multiples(N, M, [A|As], R) :-
    A =:= M, !,
    remove_multiples(N, M, As, R).
remove_multiples(N, M, [A|As], [A|R]) :-
    A < M, !,
    remove_multiples(N, M, As, R).
remove_multiples(N, M, L, R) :-
    plus(M, N, M2),
    remove_multiples(N, M2, L, R).
