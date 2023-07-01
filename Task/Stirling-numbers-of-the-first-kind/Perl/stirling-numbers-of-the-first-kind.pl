use strict;
use warnings;
use bigint;
use feature 'say';
use feature 'state';
no warnings 'recursion';
use List::Util qw(max);

sub Stirling1 {
    my($n, $k) = @_;
    return 1 unless $n || $k;
    return 0 unless $n && $k;
    state %seen;
    return ($seen{"{$n-1}|{$k-1}"} //= Stirling1($n-1, $k-1)) +
           ($seen{"{$n-1}|{$k}"  } //= Stirling1($n-1, $k  )) * ($n-1)
}

my $upto  = 12;
my $width = 1 + length max map { Stirling1($upto,$_) } 0..$upto;

say 'Unsigned Stirling1 numbers of the first kind: S1(n, k):';
print 'n\k' . sprintf "%${width}s"x(1+$upto)."\n", 0..$upto;

for my $row (0..$upto) {
    printf '%-3d', $row;
    printf "%${width}d", Stirling1($row, $_) for 0..$row;
    print "\n";
}

say "\nMaximum value from the S1(100, *) row:";
say max map { Stirling1(100,$_) } 0..100;
