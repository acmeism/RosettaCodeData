sub MAIN ($N = 5000) {
    my @points = (^$N).map: { [rand × 20 - 10, rand × 20 - 10] }

    my @candidates = @points.sort(*.[0]).rotor( 10 => -2, :partial).race.map: { closest-pair-simple(@$_) }
    say 'simple ' ~ (@candidates.sort: *.[2]).head(1).gist;
    @candidates    = @points.sort(*.[0]).rotor( 10 => -2, :partial).race.map: { closest-pair(@$_)        }
    say 'real '   ~ (@candidates.sort: *.[2]).head(1).gist;
}

sub dist-squared(@a, @b) { (@a[0] - @b[0])² + (@a[1] - @b[1])² }

sub closest-pair-simple(@points is copy) {
    return ∞ if @points < 2;
    my ($a, $b, $d) = |@points[0,1], dist-squared(|@points[0,1]);
    while @points {
        my \p = pop @points;
        for @points -> \l {
            ($a, $b, $d) = p, l, $_ if $_ < $d given dist-squared(p, l);
        }
    }
    $a, $b, $d.sqrt
}

sub closest-pair(@r) {
    closest-pair-real (@r.sort: *.[0]), (@r.sort: *.[1])
}

sub closest-pair-real(@rx, @ry) {
    return closest-pair-simple(@rx) if @rx ≤ 3;

    my \N  = @rx;
    my \midx = ceiling(N/2) - 1;
    my @PL := @rx[     0 ..  midx];
    my @PR := @rx[midx+1 ..^ N   ];
    my \xm  = @rx[midx;0];
    (.[0] ≤ xm ?? my @yR !! my @yL).push: @$_ for @ry;
    my (\al, \bl, \dL) = closest-pair-real(@PL, @yR);
    my (\ar, \br, \dR) = closest-pair-real(@PR, @yL);
    my ($w1, $w2, $closest) = dR < dL ?? (ar, br, dR) !! (al, bl, dL);
    my @yS = @ry.grep: { (xm - .[0]).abs < $closest }

    for 0 ..^ @yS -> \i {
        for i+1 ..^ @yS -> \k {
            next unless @yS[k;1] - @yS[i;1] < $closest;
            ($w1, $w2, $closest) = |@yS[k, i], $_ if $_ < $closest given dist-squared(|@yS[k, i]).sqrt;
        }
    }
    $w1, $w2, $closest
}
