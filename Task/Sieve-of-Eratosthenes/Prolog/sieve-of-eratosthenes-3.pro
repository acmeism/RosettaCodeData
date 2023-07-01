primes(X, PS) :- X > 1, range(2, X, R), sieve(X, R, PS).

sieve(X, [H | T], [H | T]) :- H*H > X, !.
sieve(X, [H | T], [H | S]) :- maplist( mult(H), [H | T], MS),
                              remove(MS, T, R), sieve(X, R, S).
