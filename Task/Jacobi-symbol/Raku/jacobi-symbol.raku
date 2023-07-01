# Jacobi function
sub infix:<J> (Int $k is copy, Int $n is copy where * % 2) {
    $k %= $n;
    my $jacobi = 1;
    while $k {
        while $k %% 2 {
            $k div= 2;
            $jacobi *= -1 if $n % 8 == 3 | 5;
        }
        ($k, $n) = $n, $k;
        $jacobi *= -1 if 3 == $n%4 & $k%4;
        $k %= $n;
    }
    $n == 1 ?? $jacobi !! 0
}

# Testing

my $maxa = 30;
my $maxn = 29;

say 'n\k ', (1..$maxa).fmt: '%3d';
say '   ', '-' x 4 * $maxa;
for 1,*+2 … $maxn -> $n {
    print $n.fmt: '%3d';
    for 1..$maxa -> $k {
        print ($k J $n).fmt: '%4d';
    }
    print "\n";
}
