use List::Util qw(sum);
use constant pi => 3.14159265;

sub legendre_pair {
    my($n, $x) = @_;
    if ($n == 1) { return $x, 1 }
    my ($m1, $m2) = legendre_pair($n - 1, $x);
    my $u = 1 - 1 / $n;
    (1 + $u) * $x * $m1 - $u * $m2, $m1;
}

sub legendre {
    my($n, $x) = @_;
    (legendre_pair($n, $x))[0]
}

sub legendre_prime {
    my($n, $x) = @_;
    if ($n == 0) { return 0 }
    if ($n == 1) { return 1 }
    my ($m0, $m1) = legendre_pair($n, $x);
    ($m1 - $x * $m0) * $n / (1 - $x**2);
}

sub approximate_legendre_root {
    my($n, $k) = @_;
    my $t = (4*$k - 1) / (4*$n + 2);
    (1 - ($n - 1) / (8 * $n**3)) * cos(pi * $t);
}

sub newton_raphson {
    my($n, $r) = @_;
    while (abs(my $dr = - legendre($n,$r) / legendre_prime($n,$r)) >= 2e-16) {
        $r += $dr;
    }
    $r;
}

sub legendre_root {
    my($n, $k) = @_;
    newton_raphson($n, approximate_legendre_root($n, $k));
}

sub weight {
    my($n, $r) = @_;
    2 / ((1 - $r**2) * legendre_prime($n, $r)**2)
}

sub nodes {
    my($n) = @_;
    my %node;
    $node{'0'} = weight($n, 0) if 0 != $n%2;
    for (1 .. int $n/2) {
        my $r = legendre_root($n, $_);
        my $w = weight($n, $r);
        $node{$r} = $w; $node{-$r} = $w;
    }
    return %node
}

sub quadrature {
    our($n, $a, $b) = @_;
    sub scale { ($_[0] * ($b - $a) + $a + $b) / 2 }
    %nodes = nodes($n);
    ($b - $a) / 2 * sum map { $nodes{$_} * exp(scale($_)) } keys %nodes;
}

printf("Gauss-Legendre %2d-point quadrature ∫₋₃⁺³ exp(x) dx ≈ %.13f\n", $_, quadrature($_, -3, +3) )
        for 5 .. 10, 20;
