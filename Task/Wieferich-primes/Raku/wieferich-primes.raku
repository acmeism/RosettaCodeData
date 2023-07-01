put "Wieferich primes less than 5000: ", join ', ', ^5000 .grep: { .is-prime and not ( exp($_-1, 2) - 1 ) % .² };
