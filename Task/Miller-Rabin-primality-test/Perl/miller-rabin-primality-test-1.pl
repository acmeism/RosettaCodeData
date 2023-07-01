use bigint try => 'GMP';

sub is_prime {
    my ($n, $k) = @_;
    return 1 if $n == 2;
    return 0 if $n < 2 or $n % 2 == 0;

    my $d = $n - 1;
    my $s = 0;

    while (!($d % 2)) {
        $d /= 2;
        $s++;
    }

  LOOP: for (1 .. $k) {
        my $a = 2 + int(rand($n - 2));

        my $x = $a->bmodpow($d, $n);
        next if $x == 1 or $x == $n - 1;

        for (1 .. $s - 1) {
            $x = ($x * $x) % $n;
            return 0  if $x == 1;
            next LOOP if $x == $n - 1;
        }
        return 0;
    }
    return 1;
}

print join ", ", grep { is_prime $_, 10 } (1 .. 1000);
