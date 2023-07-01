use strict;
use warnings;
use feature 'say';
use List::AllUtils <firstidx max>;
use ntheory qw/fromdigits todigitstring primes/;

my(%prime_base, %max_bases, $l);

my $chars  = 5;
my $upto   = fromdigits( '1' . 'Z' x $chars, 36);
my @primes = @{primes( $upto )};

for my $base (2..36) {
    my $n = todigitstring($base-1, $base) x $chars;
    my $threshold = fromdigits($n, $base);
    my $i = firstidx { $_ > $threshold } @primes;
    map { push @{$prime_base{ todigitstring($primes[$_],$base) }}, $base } 0..$i-1;
}

$l = length and $max_bases{$l} = max( $#{$prime_base{$_}}, $max_bases{$l} // 0 ) for keys %prime_base;

for my $m (1 .. $chars) {
    say "$m character strings that are prime in maximum bases: ", 1+$max_bases{$m};
    for (sort grep { length($_) ==  $m } keys %prime_base) {
        my @bases = @{($prime_base{$_})[0]};
        say "$_: " . join ' ', @bases if $max_bases{$m} eq $#bases;
    }
    say ''
}
