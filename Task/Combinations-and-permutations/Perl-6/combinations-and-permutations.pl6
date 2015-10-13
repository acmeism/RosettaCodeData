multi P($n, $k) { [*] $n - $k + 1 .. $n }
multi C($n, $k) { P($n, $k) / [*] 1 .. $k }

sub lstirling(\n) {
    n < 10 ?? lstirling(n+1) - log(n+1) !!
    .5*log(2*pi*n)+ n*log(n/e+1/(12*e*n))
}

role Logarithm {
    method gist {
	my $e = (self/10.log).Int;
	sprintf "%.8fE%+d", exp(self - $e*10.log), $e;
    }
}
multi P($n, $k, :$float!) {
    (lstirling($n) - lstirling($n -$k))
    but Logarithm
}
multi C($n, $k, :$float!) {
    (lstirling($n) - lstirling($n -$k) - lstirling($k))
    but Logarithm
}

say "Exact results:";
for 1..12 -> $n {
    my $p = $n div 3;
    say "P($n, $p) = ", P($n, $p);
}

for 10, 20 ... 60 -> $n {
    my $p = $n div 3;
    say "C($n, $p) = ", C($n, $p);
}

say '';
say "Floating point approximations:";
for 5, 50, 500, 1000, 5000, 15000 -> $n {
    my $p = $n div 3;
    say "P($n, $p) = ", P($n, $p, :float);
}

for 100, 200 ... 1000 -> $n {
    my $p = $n div 3;
    say "C($n, $p) = ", C($n, $p, :float);
}
