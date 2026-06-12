use strict;
use warnings;
use feature 'say';
use Math::AnyNum qw(:overload);

sub msb {
    my($n, $base) = (shift, 0);
    $base++ while $n >>= 1;
    $base;
}

sub lsb {
    my $n = shift;
    msb($n & -$n);
}

sub nim_sum {
    my($x,$y) = @_;
    $x ^ $y
}

sub nim_prod {
    no warnings qw(recursion);
    my($x,$y) = @_;
    return $x * $y if $x < 2 or $y < 2;
    my $h = 2 ** lsb($x);
    return nim_sum( nim_prod($h, $y), nim_prod(nim_sum($x,$h), $y)) if $x > $h;
    return nim_prod($y,$x) if lsb($y) < msb($y);
    return $x * $y unless my $comp = lsb($x) & lsb($y);
    $h = 2 ** lsb($comp);
    nim_prod(nim_prod(($x >> $h),($y >> $h)), (3 << ($h - 1)));
}

my $upto = 15;
for (['+', \&nim_sum], ['*', \&nim_prod]) {
    my($op, $f) = @$_;
    print " $op |"; printf '%3d', $_ for 0..$upto;
    say "\n───┼" . ('────' x ($upto-3));
    for my $r (0..$upto) {
        printf('%2s |', $r);
        printf '%3s', &$f($r, $_) for 0..$upto;
        print "\n";
    }
    print "\n";
}

say nim_sum(21508, 42689);
say nim_prod(21508, 42689);
say nim_sum(2150821508215082150821508, 4268942689426894268942689);
say nim_prod(2150821508215082150821508, 4268942689426894268942689); # pretty slow
