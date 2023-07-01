sub kaprekar-generator( :$base = 10 ) {
    my $base-m1 = $base - 1;
    gather loop (my $place = 1; ; ++$place) {
        my $nend = $base ** $place;
        loop (my $n = $base ** ($place - 1); $n < $nend; ++$n) {
            if $n * ($n - 1) %% $base-m1 {
                my $pend = $place * 2;
                loop (my $p = $place; $p < $pend; ++$p) {
                    my $B = $base ** $p;
                    my $lo = $n * ($B - $n) div ($B - 1);
                    my $hi = floor $n - $lo;
                    if $n * $n == $hi * $B + $lo and $lo {
                        take [$n, $hi, $lo];
                        last;
                    }
                }
            }
        }
    }
}

print " $_[0]" for kaprekar-generator() ...^ *.[0] >= 10_000;
say "\n";

say "Base 10 Kaprekar numbers < :10<1_000_000> = ", +(kaprekar-generator() ...^ *.[0] >= 1000000);
say '';

say "Base 17 Kaprekar numbers < :17<1_000_000>";

my &k17-gen = &kaprekar-generator.assuming(:base(17));

for k17-gen() ...^ *.[0] >= :17<1000000> -> @r {
    my ($n,$h,$l) = @r;
    my $n17 = $n.base(17);
    my $s = $n * $n;
    my $s17 = $s.base(17);
    my $h17 = $h.base(17);
    my $l17 = $l.base(17);
    $l17 = '0' x ($s17.chars - $h17.chars - $l17.chars) ~ $l17;
    say "$n $n17 $s17 ($h17 + $l17)";
}
