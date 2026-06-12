my @k = <a b c>;
my $n = 2;

say @k[.polymod: +@k xx $n-1] for ^@k**$n
