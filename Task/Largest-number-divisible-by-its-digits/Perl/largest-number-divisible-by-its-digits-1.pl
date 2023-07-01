my $step = 9 * 8 * 7;                               # 504, interval between tests

my $initial = int(9876432 / $step) * $step;         # largest 7 digit multiple of 504 < 9876432

for($test = $initial; $test > 0 ; $test -= $step) { # decrement by 504
    next if $test =~ /[05]/;                        # skip numbers containing 0 or 5
    next if $test =~ /(.).*\1/;                     # skip numbers with non unique digits

    for (split '', $test) {                         # skip numbers that don't divide evenly by all digits
        next unless ($test / $_) % 1;
    }

    printf "Found $test after %d steps\n", ($initial-$test)/$step;
    for (split '', $test) {
       printf "%s / %s = %s\n", $test, $_, $test / $_;
    }
    last
}
