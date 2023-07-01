use strict;
use warnings;
use feature <state say>;
use bignum;
use ntheory 'is_prime';
use List::Util <sum head>;
use List::Lazy 'lazy_list';

my $upto = 20;

my $pell_recur       = lazy_list { state @p = (0, 1); push @p, 2*$p[1] + $p[0]; shift @p };
my $pell_lucas_recur = lazy_list { state @p = (2, 2); push @p, 2*$p[1] + $p[0]; shift @p };

my @pell;
push @pell, $pell_recur->next() for 1..1500; #wart;

my @pell_lucas;
push @pell_lucas, $pell_lucas_recur->next() for 1..$upto+1;

say "First $upto Pell numbers:";
say join ' ', @pell[0..$upto-1];

say "\nFirst $upto Pell-Lucas numbers:";
say join ' ', @pell_lucas[0..$upto-1];

say "\nFirst $upto rational approximations of √2:";
say sprintf "%d/%d - %1.16f", $pell[$_-1] + $pell[$_], $pell[$_], ($pell[$_-1]+$pell[$_])/$pell[$_] for 1..$upto;

say "\nFirst $upto Pell primes:";
say join "\n", head $upto, grep { is_prime $_ } @pell;

say "\nIndices of first $upto Pell primes:";
say join ' ', head $upto, grep { is_prime($pell[$_]) and $_ } 0..$#pell;

say "\nFirst $upto Newman-Shank-Williams numbers:";
say join ' ', map { $pell[2 * $_] + $pell[2 * $_+1] } 0..$upto-1;

say "\nFirst $upto near isoceles right tringles:";
map {
    my $y = 2*$_ + 1;
    my $x = sum @pell[0..$y-1];
    printf "(%d, %d, %d)\n", $x, $x+1, $pell[$y]
} 1..$upto;
