use strict;
use warnings;
no warnings 'recursion';
use experimental 'signatures';

sub continued_fraction ($a, $b, $n = 100) {
    $a->() + ($n and $b->() / continued_fraction($a, $b, $n-1));
}

printf "√2  ≈ %.9f\n", continued_fraction do { my $n; sub { $n++ ? 2 : 1  } },              sub { 1                 };
printf "e   ≈ %.9f\n", continued_fraction do { my $n; sub { $n++ or 2     } },  do { my $n; sub { $n++ or 1       } };
printf "π   ≈ %.9f\n", continued_fraction do { my $n; sub { $n++ ? 6 : 3  } },  do { my $n; sub { (2*$n++ + 1)**2 } }, 1000;
printf "π/2 ≈ %.9f\n", continued_fraction do { my $n; sub { 1/($n++ or 1) } },              sub { 1                 }, 1000;
