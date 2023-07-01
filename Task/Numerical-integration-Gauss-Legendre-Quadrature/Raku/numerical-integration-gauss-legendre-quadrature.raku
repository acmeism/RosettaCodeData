multi legendre-pair(    1 , $x) { $x, 1 }
multi legendre-pair(Int $n, $x) {
    my ($m1, $m2) = legendre-pair($n - 1, $x);
    my \u = 1 - 1 / $n;
    (1 + u) * $x * $m1 - u * $m2, $m1;
}

multi legendre(    0 , $ ) { 1 }
multi legendre(Int $n, $x) { legendre-pair($n, $x)[0] }

multi legendre-prime(    0 , $ ) { 0 }
multi legendre-prime(    1 , $ ) { 1 }
multi legendre-prime(Int $n, $x) {
    my ($m0, $m1) = legendre-pair($n, $x);
    ($m1 - $x * $m0) * $n / (1 - $x**2);
}

sub approximate-legendre-root(Int $n, Int $k) {
    # Approximation due to Francesco Tricomi
    my \t = (4*$k - 1) / (4*$n + 2);
    (1 - ($n - 1) / (8 * $n**3)) * cos(pi * t);
}

sub newton-raphson(&f, &f-prime, $r is copy, :$eps = 2e-16) {
    while abs(my \dr = - f($r) / f-prime($r)) >= $eps {
        $r += dr;
    }
    $r;
}

sub legendre-root(Int $n, Int $k) {
    newton-raphson(&legendre.assuming($n), &legendre-prime.assuming($n),
                   approximate-legendre-root($n, $k));
}

sub weight(Int $n, $r) { 2 / ((1 - $r**2) * legendre-prime($n, $r)**2) }

sub nodes(Int $n) {
    flat gather {
        take 0 => weight($n, 0) if $n !%% 2;
        for 1 .. $n div 2 {
            my $r = legendre-root($n, $_);
            my $w = weight($n, $r);
            take $r => $w, -$r => $w;
        }
    }
}

sub quadrature(Int $n, &f, $a, $b, :@nodes = nodes($n)) {
    sub scale($x) { ($x * ($b - $a) + $a + $b) / 2 }
    ($b - $a) / 2 * [+] @nodes.map: { .value * f(scale(.key)) }
}

say "Gauss-Legendre $_.fmt('%2d')-point quadrature ∫₋₃⁺³ exp(x) dx ≈ ",
         quadrature($_, &exp, -3, +3) for flat 5 .. 10, 20;
