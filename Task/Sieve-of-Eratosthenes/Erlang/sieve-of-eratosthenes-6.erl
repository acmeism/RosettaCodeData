-module(primesieve).
-export([primes/1]).

mult(N, Limit) ->
    case Limit > N * N of
        true -> lists:seq(N * N, Limit, N);
        false -> []
    end.

primes(Limit) ->
    case Limit > 1 of
        true -> sieve(Limit, 3, [2] ++ lists:seq(3, Limit, 2), mult(3, Limit));
        false -> []
    end.

sieve(Limit, D, S, M) ->
    case Limit < D * D of
        true -> S;
        false -> sieve(Limit, D + 2, S -- M, mult(D + 2, Limit))
    end.
