use feature 'say';
use ntheory qw(is_prime powmod);

say 'Wieferich primes less than 5000: ' . join ', ', grep { is_prime($_) and powmod(2, $_-1, $_*$_) == 1 } 1..5000;
