use bigint;  # Very slow, but consistent results even with 32-bit Perl

my $hex = 'FEDCBA987654321';                      # largest possible hex number
$step = Math::BigInt::blcm(1..15);
$initial = int(hex($hex) / $step) * $step;

for($num = $initial; $num > 0 ; $num -= $step) {  # decrement by lcm

    my $test = sprintf '%x', $num;
    next if $test =~ /0/;                         # skip numbers containing 0
    next if $test =~ /(.).*\1/;                   # skip numbers with non unique digits

    push @res, sprintf "Found $test after %d steps\n", ($initial-$num)/$step;
    push @res, ' 'x12 . 'In base 16' . ' 'x36 . 'In base 10';
    for (split '', $test) {
        push @res, sprintf "%s / %s = %x  |  %d / %2d = %19d",
          $test, $_, $num / hex($_),
          $num, hex($_), $num / hex($_);
    }
    last
}

print join "\n", @res;
