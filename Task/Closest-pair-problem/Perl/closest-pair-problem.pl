use strict;
use warnings;
use POSIX qw(ceil);

sub dist {
   my ($a, $b) = @_;
   return sqrt(($a->[0] - $b->[0])**2 +
               ($a->[1] - $b->[1])**2)
}

sub closest_pair_simple {
    my @points = @{ shift @_ };
    my ($a, $b, $d) = ( $points[0], $points[1], dist($points[0], $points[1]) );
    while( @points ) {
        my $p = pop @points;
        for my $l (@points) {
            my $t = dist($p, $l);
            ($a, $b, $d) = ($p, $l, $t) if $t < $d;
        }
    }
    $a, $b, $d
}

sub closest_pair {
   my @r = @{ shift @_ };
   closest_pair_real( [sort { $a->[0] <=> $b->[0] } @r], [sort { $a->[1] <=> $b->[1] } @r] )
}

sub closest_pair_real {
    my ($rx, $ry) = @_;
    return closest_pair_simple($rx) if scalar(@$rx) <= 3;

    my(@yR, @yL, @yS);
    my $N = @$rx;
    my $midx = ceil($N/2)-1;
    my @PL = @$rx[      0 .. $midx];
    my @PR = @$rx[$midx+1 .. $N-1];
    my $xm = $$rx[$midx]->[0];
    $_->[0] <= $xm ? push @yR, $_ : push @yL, $_ for @$ry;
    my ($al, $bl, $dL) = closest_pair_real(\@PL, \@yR);
    my ($ar, $br, $dR) = closest_pair_real(\@PR, \@yL);
    my ($w1, $w2, $closest) = $dR > $dL ? ($al, $bl, $dL) : ($ar, $br, $dR);
    abs($xm - $_->[0]) < $closest and push @yS, $_ for @$ry;

    for my $i (0 .. @yS-1) {
        my $k = $i + 1;
        while ( $k <= $#yS and ($yS[$k]->[1] - $yS[$i]->[1]) < $closest ) {
            my $d = dist($yS[$k], $yS[$i]);
            ($w1, $w2, $closest) = ($yS[$k], $yS[$i], $d) if $d < $closest;
            $k++;
        }
    }
    $w1, $w2, $closest
}

my @points;
push @points, [rand(20)-10, rand(20)-10] for 1..5000;
printf "%.8f between (%.5f, %.5f), (%.5f, %.5f)\n", $_->[2], @{$$_[0]}, @{$$_[1]}
    for [closest_pair_simple(\@points)], [closest_pair(\@points)];
