use strict;
use warnings;
no warnings qw(recursion);
use Math::AnyNum qw(:overload);
use Memoize;

memoize('partitionsP');
memoize('partDiff');

sub partDiffDiff { my($n) = @_; $n%2 != 0 ? ($n+1)/2 : $n+1 }

sub partDiff { my($n) = @_; $n<2 ? 1 : partDiff($n-1) + partDiffDiff($n-1) }

sub partitionsP {
    my($n) = @_;
    return 1 if $n < 2;

    my $psum = 0;
    for my $i (1..$n) {
        my $pd = partDiff($i);
        last if $pd > $n;
        if ( (($i-1)%4) < 2 ) { $psum += partitionsP($n-$pd) }
        else                  { $psum -= partitionsP($n-$pd) }
    }
    return $psum
}

print partitionsP($_) . ' ' for 0..25; print "\n";
print partitionsP(6666) . "\n";
