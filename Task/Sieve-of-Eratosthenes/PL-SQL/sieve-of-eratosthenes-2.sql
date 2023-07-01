select column_value as prime_number
from   table(sieve_of_eratosthenes.find_primes(30));

PRIME_NUMBER
------------
	   2
	   3
	   5
	   7
	  11
	  13
	  17
	  19
	  23
	  29

10 rows selected.

Elapsed: 00:00:00.01

select count(*) as number_of_primes, sum(column_value) as sum_of_primes
from   table(sieve_of_eratosthenes.find_primes(1e7));

NUMBER_OF_PRIMES   SUM_OF_PRIMES
---------------- ---------------
          664579   3203324994356

Elapsed: 00:00:02.60
