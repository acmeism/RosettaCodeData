use strict;
use warnings;

use ntheory 'is_prime';
use List::Util qw(sum);

sub digital_root {
    my ($n) = @_;
    do { $n = sum split '', $n } until 1 == length $n;
    $n
}

my($low, $high, $cnt, @nice_primes) = (500,1000);
is_prime($_) and is_prime(digital_root($_)) and push @nice_primes, $_ for $low+1 .. $high-1;

$cnt = @nice_primes;
print "Nice primes between $low and $high (total of $cnt):\n" .
(sprintf "@{['%5d' x $cnt]}", @nice_primes[0..$cnt-1]) =~ s/(.{55})/$1\n/gr;
