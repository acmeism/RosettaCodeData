primes(X, PS) :- X > 1, range(2, X, R), sieve(R, PS).

range(X, X, [X]) :- !.
range(X, Y, [X | R]) :- X < Y, X1 is X + 1, range(X1, Y, R).

mult(A, B, C) :- C is A*B.

sieve([X], [X]) :- !.
sieve([H | T], [H | S]) :- maplist( mult(H), [H | T], MS),
                           remove(MS, T, R), sieve(R, S).

remove( _,       [],      []     ) :- !.
remove( [H | X], [H | Y], R      ) :- !, remove(X, Y, R).
remove( X,       [H | Y], [H | R]) :- remove(X, Y, R).
