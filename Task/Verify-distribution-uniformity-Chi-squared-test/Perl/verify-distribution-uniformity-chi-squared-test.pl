use List::Util qw(sum reduce);
use constant pi => 3.14159265;

sub incomplete_G_series {
    my($s, $z) = @_;
    my $n = 10;
    push @numers, $z**$_ for 1..$n;
    my @denoms = $s+1;
    push @denoms, $denoms[-1]*($s+$_) for 2..$n;
    my $M = 1;
    $M += $numers[$_-1]/$denoms[$_-1] for 1..$n;
    $z**$s / $s * exp(-$z) * $M;
}

sub G_of_half {
    my($n) = @_;
    if ($n % 2) { f(2*$_) / (4**$_ * f($_)) * sqrt(pi) for int ($n-1) / 2 }
    else        { f(($n/2)-1) }
}

sub f { reduce { $a * $b } 1, 1 .. $_[0] } # factorial

sub chi_squared_cdf {
    my($k, $x) = @_;
    my $f = $k < 20 ? 20 : 10;
    if ($x == 0)                  { 0.0 }
    elsif ($x < $k + $f*sqrt($k)) { incomplete_G_series($k/2, $x/2) / G_of_half($k) }
    else                          { 1.0 }
}
sub chi_squared_test {
    my(@bins) = @_;
    $significance = 0.05;
    my $n = @bins;
    my $N = sum @bins;
    my $expected = $N / $n;
    my $chi_squared = sum map { ($_ - $expected)**2 / $expected } @bins;
    my $p_value = 1 - chi_squared_cdf($n-1, $chi_squared);
    return $chi_squared, $p_value, $p_value > $significance ? 'True' : 'False';
}

for $dataset ([199809, 200665, 199607, 200270, 199649], [522573, 244456, 139979, 71531, 21461]) {
    printf "C2 = %10.3f, p-value = %.3f, uniform = %s\n", chi_squared_test(@$dataset);
}
