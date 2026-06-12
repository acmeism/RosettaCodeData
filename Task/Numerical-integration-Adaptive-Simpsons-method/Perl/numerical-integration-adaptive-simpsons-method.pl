use strict;
use warnings;

sub adaptive_Simpson_quadrature {
    my($f, $left, $right, $eps) = @_;
    my $lf = eval "$f($left)";
    my $rf = eval "$f($right)";
    my ($mid, $midf, $whole) = Simpson_quadrature_mid($f, $left, $lf, $right, $rf);
    return recursive_Simpsons_asr($f, $left, $lf, $right, $rf, $eps, $whole, $mid, $midf);

    sub Simpson_quadrature_mid {
        my($g, $l, $lf, $r, $rf) = @_;
        my $mid = ($l + $r) / 2;
        my $midf = eval "$g($mid)";
        ($mid, $midf, abs($r - $l) / 6 * ($lf + 4 * $midf + $rf))
    }

    sub recursive_Simpsons_asr {
        my($h, $a, $fa, $b, $fb, $eps, $whole, $m, $fm) = @_;
        my ($lm, $flm, $left)  = Simpson_quadrature_mid($h, $a, $fa, $m, $fm);
        my ($rm, $frm, $right) = Simpson_quadrature_mid($h, $m, $fm, $b, $fb);
        my $delta = $left + $right - $whole;
        abs($delta) <= 15 * $eps
            ? $left + $right + $delta / 15
            : recursive_Simpsons_asr($h, $a, $fa, $m, $fm, $eps/2, $left,  $lm, $flm) +
              recursive_Simpsons_asr($h, $m, $fm, $b, $fb, $eps/2, $right, $rm, $frm)
    }
}

my ($a, $b) = (0, 1);
my $sin = adaptive_Simpson_quadrature('sin', $a, $b, 1e-9);
printf "Simpson's integration of sine from $a to $b = %.9f", $sin
