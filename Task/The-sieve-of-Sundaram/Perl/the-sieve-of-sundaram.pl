use strict;
use warnings;
use feature 'say';

my @sieve;
my $nth = 1_000_000;
my $k = 2.4 * $nth * log($nth) / 2;

$sieve[$k] = 0;
for my $i (1 .. $k) {
    my $j = $i;
    while ((my $l = $i + $j + 2 * $i * $j) < $k) {
        $sieve[$l] = 1;
        $j++
    }
}

$sieve[0] = 1;
my @S = (grep { $_ } map { ! $sieve[$_] and 1+$_*2 } 0..@sieve)[0..99];
say "First 100 Sundaram primes:\n" .
    (sprintf "@{['%5d' x 100]}", @S) =~ s/(.{50})/$1\n/gr;

my ($count, $index);
for (@sieve) {
    $count += !$_;
    (say "One millionth: " . (1+2*$index)) and last if $count == $nth;
    ++$index;
}
