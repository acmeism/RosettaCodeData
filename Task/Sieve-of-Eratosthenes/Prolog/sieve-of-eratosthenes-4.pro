primes(X, PS) :- X > 1, range(2, X, R), sieve(X, R, PS).

range(X, X, [X]) :- !.
range(X, Y, [X | R]) :- X < Y, X1 is X + 1, range(X1, Y, R).

sieve(X, [H | T], [H | T]) :- H*H > X, !.
sieve(X, [H | T], [H | S]) :- mults( H, X, MS), remove(MS, T, R), sieve(X, R, S).

mults( H, Lim, MS):- M is H*H, mults( H, M, Lim, MS).
mults( _, M, Lim, []):- M > Lim, !.
mults( H, M, Lim, [M|MS]):- M2 is M+H, mults( H, M2, Lim, MS).

remove( _,       [],      []     ) :- !.
remove( [H | X], [H | Y], R      ) :- !, remove(X, Y, R).
remove( [H | X], [G | Y], R      ) :- H < G, !, remove(X, [G | Y], R).
remove( X,       [H | Y], [H | R]) :- remove(X, Y, R).
