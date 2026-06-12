use strict;
use warnings;
use ntheory 'primes';

sub count {
    my($n,$p) = @_;
    my $c = -1;
    do { $c++ } until $$p[$c] > $n;
    return $c;
}

my(@rp,@mem);
my $primes = primes( 100_000_000 );

sub r_prime {
    my $n = shift;
    for my $x ( reverse 1 .. int 4*$n * log(4*$n) / log 2 ) {
        my $y = int $x / 2;
        return 1 + $x if ($mem[$x] //= count($x,$primes)) - ($mem[$y] //= count($y,$primes)) < $n
    }
}

push @rp, r_prime($_) for 1..100;
print "First 100:\n" . (sprintf "@{['%5d' x 100]}", @rp) =~ s/(.{100})/$1\n/gr;

print "\n\n 1000th: " . r_prime( 1000) . "\n";
print   "\n10000th: " . r_prime(10000) . "\n"; # faster with 'ntheory' function 'ramanujan_primes'
