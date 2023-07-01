% almostPrime(K, +Take, List) succeeds if List can be unified with the
% first Take K-almost-primes.
% Notice that K need not be specified.
% To avoid having to cache or recompute the first Take primes, we define
% almostPrime/3 in terms of almostPrime/4 as follows:
%
almostPrime(K, Take, List) :-
  % Compute the list of the first Take primes:
  nPrimes(Take, Primes),
  almostPrime(K, Take, Primes, List).

almostPrime(1, Take, Primes, Primes).

almostPrime(K, Take, Primes, List) :-
  generate(2, K),  % generate K >= 2
  K1 is K - 1,
  almostPrime(K1, Take, Primes, L),
  multiplylist( Primes, L, Long),
  sort(Long, Sorted), % uniquifies
  take(Take, Sorted, List).
