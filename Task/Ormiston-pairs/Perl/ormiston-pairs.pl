use strict;
use warnings;
use feature 'say';
use ntheory <primes vecfirstidx>;

my(@O,$pairs);
my @primes = @{ primes(1,1e8) };
my @A = map { join '', sort split '', $_ } @primes;
for (1..$#primes-1) { push @O, $_ if $A[$_] eq $A[$_+1] }

say "First 30 Ormiston pairs:";
$pairs .= sprintf "(%5d,%5d) ", $primes[$_], $primes[$_+1] for @O[0..29];
say $pairs =~ s/.{42}\K/\n/gr;

for (
  [1e5, 'one hundred thousand'],
  [1e6, 'one million'],
  [1e7, 'ten million']
) {
    my($limit,$text) = @$_;
    my $i = vecfirstidx { $primes[$_] >= $limit } @O;
    printf "%4d Ormiston pairs before %s\n", $i, $text;
}
