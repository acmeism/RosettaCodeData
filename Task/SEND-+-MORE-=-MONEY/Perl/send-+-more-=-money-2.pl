use v5.36;

my $s = 7;
while (++$s <= 9) {
    my $e = -1;
    while (++$e <= 9) {
        next if $e == $s;
        my $n = -1;
        while (++$n <= 9) {
            next if grep { $n == $_ } $s,$e;
            my $d = -1;
            while (++$d <= 9) {
                next if grep { $d == $_ } $s,$e,$n;
                my $send = $s*10**3 + $e*10**2 + $n*10 + $d;
                my ($m, $o) = (1, -1);
                while (++$o <= 9) {
                    next if grep { $o == $_ } $s,$e,$n,$d,$m;
                    my $r = -1;
                    while (++$r <= 9) {
                        next if grep { $r == $_ } $s,$e,$n,$d,$m,$o;
                        my $more = $m*10**3 + $o*10**2 + $r*10 + $e;
                        my $y = -1;
                        while (++$y <= 9) {
                            next if grep { $y == $_ } $s,$e,$n,$d,$m,$o,$r;
                            my $money = $m*10**4 + $o*10**3 + $n*10**2 + $e*10 + $y;
                            next unless $send + $more == $money;
                            say "SEND + MORE == MONEY\n$send + $more == $money";
                        }
                    }
                }
            }
        }
    }
}

