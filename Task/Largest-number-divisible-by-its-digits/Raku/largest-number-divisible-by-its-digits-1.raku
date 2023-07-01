my $magic-number = 9 * 8 * 7;                        # 504

my $div = 9876432 div $magic-number * $magic-number; # largest 7 digit multiple of 504 < 9876432

for $div, { $_ - $magic-number } ... * -> $test {    # only generate multiples of 504
    next if $test ~~ / <[05]> /;                     # skip numbers containing 0 or 5
    next if $test ~~ / (.).*$0 /;                    # skip numbers with non unique digits

    say "Found $test";                               # Found a solution, display it
    for $test.comb {
        printf "%s / %s = %s\n", $test, $_, $test / $_;
    }
    last
}
