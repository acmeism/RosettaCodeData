sub benford(@a) { bag +« @a».comb: /<( <[ 1..9 ]> )> <[ , . \d ]>*/ }

sub show(%distribution) {
    printf "%9s %9s  %s\n", <Actual Expected Deviation>;
    for 1 .. 9 -> $digit {
        my $actual = %distribution{$digit} * 100 / [+] %distribution.values;
        my $expected = (1 + 1 / $digit).log(10) * 100;
        printf "%d: %5.2f%% | %5.2f%% | %.2f%%\n",
          $digit, $actual, $expected, abs($expected - $actual);
    }
}

multi MAIN($file) { show benford $file.IO.lines }
multi MAIN() { show benford ( 1, 1, 2, *+* ... * )[^1000] }
