use strict;
use warnings;

my @a = < 1  2  3  4  5  6  7  8  9>;
my @b = <10 11 12 13 14 15 16 17 18>;
my @c = <19 20 21 22 23 24 25 26 27>;
my @d = <1  2  2  2  2  2  2  2  2 >;
my @e = < 9  0  1  2  3  4  5  6  7>;
my @f = (\@a, \@b, \@d, \@e);

# for just the three given lists
print $a[$_] . $b[$_] . $c[$_] . ' ' for 0..$#a; print "\n";

# for arbitrary number of lists
for my $i (0 .. $#{$f[0]}) {
    map {print $f[$_][$i] } 0 .. $#f and print ' '
}
print "\n";
