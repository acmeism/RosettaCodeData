use strict;
use warnings;
use List::Util <first uniq>;
use ntheory qw<pn_primorial is_prime>;

my $upto = 50;
my @candidates;
for my $p ( map { pn_primorial($_) } 1..2*$upto ) {
    push @candidates, first { is_prime($_ + $p) } 2..100*$upto;
}

my @fortunate = sort { $a <=> $b } uniq grep { is_prime $_ } @candidates;

print "First $upto distinct fortunate numbers:\n" .
    (sprintf "@{['%6d' x $upto]}", @fortunate) =~ s/(.{60})/$1\n/gr;
