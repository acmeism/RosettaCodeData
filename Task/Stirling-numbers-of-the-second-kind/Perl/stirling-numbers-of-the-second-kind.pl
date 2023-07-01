use strict;
use warnings;
use bigint;
use feature 'say';
use feature 'state';
no warnings 'recursion';
use List::Util qw(max);

sub Stirling2 {
    my($n, $k) = @_;
    my $n1 = $n - 1;
    return 1 if     $n1 == $k;
    return 0 unless $n1 && $k;
    state %seen;
    return ($seen{"{$n1}|{$k}"  } //= Stirling2($n1,$k  ) * $k) +
           ($seen{"{$n1}|{$k-1}"} //= Stirling2($n1,$k-1))
}

my $upto  = 12;
my $width = 1 + length max map { Stirling2($upto+1,$_) } 0..$upto+1;

say 'Unsigned Stirling2 numbers of the second kind: S2(n, k):';
print 'n\k' . sprintf "%${width}s"x(1+$upto)."\n", 0..$upto;

for my $row (1..$upto+1) {
    printf '%-3d', $row-1;
    printf "%${width}d", Stirling2($row, $_) for 0..$row-1;
    print "\n";
}

say "\nMaximum value from the S2(100, *) row:";
say max map { Stirling2(101,$_) } 0..100;
