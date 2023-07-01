use strict;
use warnings;
use feature 'say';
use ntheory <primes vecfirstidx>;

my(@O,$pairs);
my @primes = @{ primes(1,1e8) };
my @A = map { join '', sort split '', $_ } @primes;
for (1..$#primes-2) { push @O, $_ if $A[$_] eq $A[$_+1] and $A[$_] eq $A[$_+2] }

say "First 25 Ormiston triples:";
$pairs .= sprintf "%8d, ", $primes[$_] for @O[0..24];
$pairs =~ s/, $//;
say $pairs =~ s/.{50}\K/\n/gr;

for (
  [1e8, 'one hundred million'],
  [1e9, 'one billion'],
) {
    my($limit,$text) = @$_;
    my $i = vecfirstidx { $primes[$_] >= $limit } @O;
    printf "%3d Ormiston triples before %s\n", $i, $text;
}
