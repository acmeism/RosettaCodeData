use 5.020;
use ntheory      qw(:all);
use experimental qw(signatures);

sub divceil ($x, $y) {    # ceil(x/y)
    (($x % $y == 0) ? 0 : 1) + int($x / $y);
}

sub LC_in_range ($A, $B, $k) {

    my @LC;
    my $max_p = sqrtint($B + 1) - 1;

    $A = vecmax(pn_primorial($k + 1) >> 1, $A);

    sub ($m, $L, $lo, $k) {

        my $hi = rootint(int($B / $m), $k);

        return if ($lo > $hi);

        if ($k == 1) {

            $hi = $max_p if ($hi > $max_p);
            $lo = vecmax($lo, divceil($A, $m));
            $lo > $hi && return;

            my $t = $L - invmod($m, $L);
            $t += $L while ($t < $lo);

            for (my $p = $t ; $p <= $hi ; $p += $L) {
                if (is_prime($p)) {
                    my $n = $m * $p;
                    if (($n + 1) % ($p + 1) == 0) {
                        push @LC, $n;
                    }
                }
            }

            return;
        }

        foreach my $p (@{primes($lo, $hi)}) {
            if (gcd($m, $p + 1) == 1) {
                __SUB__->($m * $p, lcm($L, $p + 1), $p + 1, $k - 1);
            }
        }
      }
      ->(1, 1, 3, $k);

    return sort { $a <=> $b } @LC;
}

sub LC_with_n_primes ($n) {
    return if ($n < 3);

    my $x = pn_primorial($n + 1) >> 1;
    my $y = 2 * $x;

    for (; ;) {
        my @LC = LC_in_range($x, $y, $n);
        @LC and return $LC[0];
        $x = $y + 1;
        $y = 2 * $x;
    }
}

sub LC_count ($A, $B) {
    my $count = 0;
    for (my $k = 3 ; ; ++$k) {
        if (pn_primorial($k + 1) / 2 > $B) {
            last;
        }
        my @LC = LC_in_range($A, $B, $k);
        $count += @LC;
    }
    return $count;
}

say "Least Lucas-Carmichael number with n prime factors:";

foreach my $n (3 .. 12) {
    printf("%2d: %s\n", $n, LC_with_n_primes($n));
}

say "\nNumber of Lucas-Carmichael numbers less than 10^n:";

my $acc = 0;
foreach my $n (1 .. 10) {
    my $c = LC_count(10**($n - 1), 10**$n);
    printf("%2d: %s\n", $n, $acc + $c);
    $acc += $c;
}
