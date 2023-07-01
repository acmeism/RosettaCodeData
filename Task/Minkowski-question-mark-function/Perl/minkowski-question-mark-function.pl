use strict;
use warnings;
use feature 'say';
use POSIX qw(floor);

my $MAXITER = 50;

sub minkowski {
    my($x) = @_;

    return floor($x) + minkowski( $x - floor($x) ) if $x > 1 || $x < 0 ;

    my $y = my $p = floor($x);
    my ($q,$s,$d) = (1,1,1);
    my $r = $p + 1;

    while () {
        last if ( $y + ($d /= 2)  == $y ) or
                ( my $m = $p + $r) <  0   or
                ( my $n = $q + $s) <  0;
        $x < $m/$n ? ($r,$s) = ($m, $n) : ($y += $d and ($p,$q) = ($m, $n) );
    }
    return $y + $d
}

sub minkowskiInv {
    my($x) = @_;

    return floor($x) + minkowskiInv($x - floor($x)) if $x > 1 || $x < 0;
    return $x if $x == 1 || $x == 0 ;

    my @contFrac = 0;
    my $i = my $curr = 0 ; my $count = 1;

    while () {
        $x *= 2;
        if ($curr == 0) {
            if ($x < 1) {
                $count++
            } else {
                $i++;
                push @contFrac, 0;
                $contFrac[$i-1] = $count;
                ($count,$curr) = (1,1);
                $x--;
            }
        } else {
            if ($x > 1) {
                $count++;
                $x--;
            } else {
                $i++;
                push @contFrac, 0;
                @contFrac[$i-1] = $count;
                ($count,$curr) = (1,0);
            }
        }
        if ($x == floor($x)) { @contFrac[$i] = $count; last }
        last if $i == $MAXITER;
    }
    my $ret = 1 / $contFrac[$i];
    for (my $j = $i - 1; $j >= 0; $j--) { $ret = $contFrac[$j] + 1/$ret }
    return 1 / $ret
}

printf "%19.16f %19.16f\n", minkowski(0.5*(1 + sqrt(5))), 5/3;
printf "%19.16f %19.16f\n", minkowskiInv(-5/9), (sqrt(13)-7)/6;
printf "%19.16f %19.16f\n", minkowski(minkowskiInv(0.718281828)), minkowskiInv(minkowski(0.1213141516171819));
