constant @primes = 2, 3, { first * %% none(@_), (@_[* - 1], * + 2 ... *) } ... *;

say @primes[^100];
