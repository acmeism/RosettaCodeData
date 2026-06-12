sub adaptive-Simpson-quadrature(&f, $left, $right, \ε = 1e-9) {
    my $lf = f($left);
    my $rf = f($right);
    my ($mid, $midf, $whole) = Simpson-quadrature-mid(&f, $left, $lf, $right, $rf);
    return recursive-Simpsons-asr(&f, $left, $lf, $right, $rf, ε, $whole, $mid, $midf);

    sub Simpson-quadrature-mid(&g, $l, $lf, $r, $rf){
        my $mid = ($l + $r) / 2;
        my $midf = g($mid);
        ($mid, $midf, ($r - $l).abs / 6 * ($lf + 4 * $midf + $rf))
    }

    sub recursive-Simpsons-asr(&h, $a, $fa, $b, $fb, $eps, $whole, $m, $fm){
        my ($lm, $flm, $left)  = Simpson-quadrature-mid(&h, $a, $fa, $m, $fm);
        my ($rm, $frm, $right) = Simpson-quadrature-mid(&h, $m, $fm, $b, $fb);
        my $delta = $left + $right - $whole;
        $delta.abs <= 15 * $eps
            ?? $left + $right + $delta / 15
            !! recursive-Simpsons-asr(&h, $a, $fa, $m, $fm, $eps/2, $left,  $lm, $flm) +
               recursive-Simpsons-asr(&h, $m, $fm, $b, $fb, $eps/2, $right, $rm, $frm)
    }
}

my ($a, $b) = 0e0, 1e0;
my $sin = adaptive-Simpson-quadrature(&sin, $a, $b, 1e-9).round(10**-9);;
say "Simpson's integration of sine from $a to $b = $sin";
