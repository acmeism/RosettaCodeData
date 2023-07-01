use strict;
use warnings;
use feature 'say';
use ntheory qw(factorial);
use List::Util qw(max);

sub Lah {
    my($n, $k) = @_;
    return factorial($n) if $k == 1;
    return 1 if $k == $n;
    return 0 if $k > $n;
    return 0 if $k < 1 or $n < 1;
    (factorial($n) * factorial($n - 1)) / (factorial($k) * factorial($k - 1)) / factorial($n - $k)
}

my $upto = 12;
my $mx   = 1 + length max map { Lah(12,$_) } 0..$upto;

say 'Unsigned Lah numbers:  L(n, k):';
print 'n\k' . sprintf "%${mx}s"x(1+$upto)."\n", 0..1+$upto;

for my $row (0..$upto) {
    printf '%-3d', $row;
    map { printf "%${mx}d", Lah($row, $_) } 0..$row;
    print "\n";
}

say "\nMaximum value from the L(100, *) row:";
say max map { Lah(100,$_) } 0..100;
