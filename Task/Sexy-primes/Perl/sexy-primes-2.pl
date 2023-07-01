use ntheory qw/sieve_prime_cluster forprimes is_prime/;

# ... identical helper functions

my %primes = (
    sexy       => [],
    unsexy     => [],
    pair       => [ sieve_prime_cluster(1, $max-1- 6,  6) ],
    triplet    => [ sieve_prime_cluster(1, $max-1-12,  6, 12) ],
    quadruplet => [ sieve_prime_cluster(1, $max-1-18,  6, 12, 18) ],
    quintuplet => [ sieve_prime_cluster(1, $max-1-24,  6, 12, 18, 24) ],
);

forprimes {
  push @{$primes{sexy_string($_)}}, $_;
} $max-1;

# ... identical output code
