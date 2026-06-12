use strict;
use warnings;
use ntheory 'is_prime';
use Math::BigRat try => 'GMP';

sub abbr { my $d = shift; my $l = length $d; $l < 41 ? $d : substr($d,0,20) . '..' . substr($d,-20) . " ($l digits)" }

my @W = Math::BigRat->new('1/1');
push @W, $W[-1] + Math::BigRat->new(join '/', 1, $_**2) for 2..10000;

print "Wolstenholme numbers:\n";
printf "%5s: %s\n", $_, abbr $W[$_-1]->numerator() for 1..20, 5e2, 1e3, 2.5e3, 5e3, 1e4;

print "\nPrime Wolstenholme numbers:\n";
my($n,$c);
do { printf "%5s: %s\n", ++$c, abbr $W[$n]->numerator() if is_prime $W[++$n]->numerator() } until $c == 15;
