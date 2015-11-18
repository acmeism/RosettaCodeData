sub MAIN ($N = 5000) {
    my @points = (^$N).map: { [rand * 20 - 10, rand * 20 - 10] }

    my ($af, $bf, $df) = closest_pair(@points);
    say "fast $df at [$af], [$bf]";

    my ($as, $bs, $ds) = closest_pair_simple(@points);
    say "slow $ds at [$as], [$bs]";
}

sub dist-squared($a,$b) {
    ($a[0] - $b[0]) ** 2 +
    ($a[1] - $b[1]) ** 2;
}

sub closest_pair_simple(@arr is copy) {
    return Inf if @arr < 2;
    my ($a, $b, $d) = flat @arr[0,1], dist-squared(|@arr[0,1]);
    while  @arr {
        my $p = pop @arr;
        for @arr -> $l {
            my $t = dist-squared($p, $l);
            ($a, $b, $d) = $p, $l, $t if $t < $d;
        }
    }
    return $a, $b, sqrt $d;
}

sub closest_pair(@r) {
    my @ax = @r.sort: { .[0] }
    my @ay = @r.sort: { .[1] }
    return closest_pair_real(@ax, @ay);
}

sub closest_pair_real(@rx, @ry) {
    return closest_pair_simple(@rx) if @rx <= 3;

    my @xP = @rx;
    my @yP = @ry;
    my $N = @xP;

    my $midx = ceiling($N/2)-1;

    my @PL = @xP[0 .. $midx];
    my @PR = @xP[$midx+1 ..^ $N];

    my $xm = @xP[$midx][0];

    my @yR;
    my @yL;
    push ($_[0] <= $xm ?? @yR !! @yL), $_ for @yP;

    my ($al, $bl, $dL) = closest_pair_real(@PL, @yR);
    my ($ar, $br, $dR) = closest_pair_real(@PR, @yL);

    my ($m1, $m2, $dmin) = $dR < $dL
                               ?? ($ar, $br, $dR)
                               !! ($al, $bl, $dL);

    my @yS = @yP.grep: { abs($xm - .[0]) < $dmin }

    if @yS {
        my ($w1, $w2, $closest) = $m1, $m2, $dmin;
        for 0 ..^ @yS.end -> $i {
            for $i+1 ..^ @yS -> $k {
                last unless @yS[$k][1] - @yS[$i][1] < $dmin;
                my $d = sqrt dist-squared(@yS[$k], @yS[$i]);
                ($w1, $w2, $closest) = @yS[$k], @yS[$i], $d if $d < $closest;
            }

        }
        return $w1, $w2, $closest;

    } else {
        return $m1, $m2, $dmin;
    }
}
