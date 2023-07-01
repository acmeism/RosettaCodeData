sub incomplete-γ-series($s, $z) {
    my \numers = $z X** 1..*;
    my \denoms = [\*] $s X+ 1..*;
    my $M = 1 + [+] (numers Z/ denoms) ... * < 1e-6;
    $z**$s / $s * exp(-$z) * $M;
}

sub postfix:<!>(Int $n) { [*] 2..$n }

sub Γ-of-half(Int $n where * > 0) {
    ($n %% 2) ?? (($_-1)!                            given  $n    div 2)
              !! ((2*$_)! / (4**$_ * $_!) * sqrt(pi) given ($n-1) div 2);
}

# degrees of freedom constrained due to numerical limitations
sub chi-squared-cdf(Int $k where 1..200, $x where * >= 0) {
    my $f = $k < 20 ?? 20 !! 10;
    given $x {
        when 0                    { 0.0 }
        when * < $k + $f*sqrt($k) { incomplete-γ-series($k/2, $x/2) / Γ-of-half($k) }
        default                   { 1.0 }
    }
}

sub chi-squared-test(@bins, :$significance = 0.05) {
    my $n = +@bins;
    my $N = [+] @bins;
    my $expected = $N / $n;
    my $chi-squared = [+] @bins.map: { ($^bin - $expected)**2 / $expected }
    my $p-value = 1 - chi-squared-cdf($n-1, $chi-squared);
    return (:$chi-squared, :$p-value, :uniform($p-value > $significance));
}

for [< 199809 200665 199607 200270 199649 >],
    [< 522573 244456 139979  71531  21461 >]
    -> $dataset
{
    my %t = chi-squared-test($dataset);
    say 'data: ', $dataset;
    say "χ² = {%t<chi-squared>}, p-value = {%t<p-value>.fmt('%.4f')}, uniform = {%t<uniform>}";
}
