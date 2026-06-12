my $s = 7;
while ++$s ≤ 9 {
    my $e = -1;
    while ++$e ≤ 9 {
        next if $e == $s;

        my $n = -1;
        while ++$n ≤ 9 {
            next if $n == $s|$e;

            my $d = -1;
            while ++$d ≤ 9 {
                next if $d == $s|$e|$n;

                my $send = $s×10³ + $e×10² + $n×10 + $d;
                my ($m, $o) = 1, -1;
                while ++$o ≤ 9 {
                    next if $o == $s|$e|$n|$d|$m;

                    my $r = -1;
                    while ++$r ≤ 9 {
                        next if $r == $s|$e|$n|$d|$m|$o;

                        my $more = $m×10³ + $o×10² + $r×10 + $e;
                        my $y = -1;
                        while ++$y ≤ 9 {
                            next if $y == $s|$e|$n|$d|$m|$o|$r;

                            my $money = $m×10⁴ + $o×10³ + $n×10² + $e×10 + $y;
                            next unless $send + $more == $money;
                            say 'SEND + MORE == MONEY' ~ "\n$send + $more == $money";
                        }
                    }
                }
            }
        }
    }
}
printf "%.3f elapsed seconds", now - INIT now;
