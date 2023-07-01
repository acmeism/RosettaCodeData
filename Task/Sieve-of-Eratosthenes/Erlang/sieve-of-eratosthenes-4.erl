-module(sieveof).
-export([main/1,primes/1, primes/2]).

main(X) -> io:format("Primes: ~w~n", [ primes(X) ]).

primes(X) -> sieve(range(2, X)).
primes(X, Y) -> remove(primes(X), primes(Y)).

range(X, X) -> [X];
range(X, Y) -> [X | range(X + 1, Y)].

sieve([X]) -> [X];
sieve([H | T]) -> [H | sieve(remove([H * X || X <-[H | T]], T))].

remove(_, []) -> [];
remove([H | X], [H | Y]) -> remove(X, Y);
remove(X, [H | Y]) -> [H | remove(X, Y)].
