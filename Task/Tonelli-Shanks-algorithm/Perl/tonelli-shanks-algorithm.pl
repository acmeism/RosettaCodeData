use bigint;
use ntheory qw(is_prime powmod kronecker);

sub tonelli_shanks {
    my($n,$p) = @_;
    return if kronecker($n,$p) <= 0;
    my $Q = $p - 1;
    my $S = 0;
    $Q >>= 1 and $S++ while 0 == $Q%2;
    return powmod($n,int(($p+1)/4), $p) if $S == 1;

    my $c;
    for $n (2..$p) {
        next if kronecker($n,$p) >= 0;
        $c = powmod($n, $Q, $p);
        last;
    }

    my $R = powmod($n, ($Q+1) >> 1, $p ); # ?
    my $t = powmod($n, $Q, $p );
    while (($t-1) % $p) {
        my $b;
        my $t2 = $t**2 % $p;
        for (1 .. $S) {
            if (0 == ($t2-1)%$p) {
                $b = powmod($c, 1 << ($S-1-$_), $p);
                $S = $_;
                last;
            }
            $t2 = $t2**2 % $p;
        }
        $R = ($R * $b) % $p;
        $c = $b**2 % $p;
        $t = ($t * $c) % $p;
    }
    $R;
}

my @tests = (
    (10, 13),
    (56, 101),
    (1030, 10009),
    (1032, 10009),
    (44402, 100049),
    (665820697, 1000000009),
    (881398088036, 1000000000039),
);

while (@tests) {
    $n = shift @tests;
    $p = shift @tests;
    my $t = tonelli_shanks($n, $p);
    if (!$t or ($t**2 - $n) % $p) {
        printf "No solution for (%d, %d)\n", $n, $p;
    } else {
        printf "Roots of %d are (%d, %d) mod %d\n", $n, $t, $p-$t, $p;
    }
}
