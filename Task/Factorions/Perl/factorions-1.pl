use strict;
use warnings;
use ntheory qw/factorial todigits/;

my $limit = 1500000;

for my $b (9 .. 12) {
    print "Factorions in base $b:\n";
    $_ == factorial($_) and print "$_ " for 0..$b-1;

    for my $i (1 .. int $limit/$b) {
        my $sum;
        my $prod = $i * $b;

        for (reverse todigits($i, $b)) {
            $sum += factorial($_);
            $sum = 0 && last if $sum > $prod;
        }

        next if $sum == 0;
        ($sum + factorial($_) == $prod + $_) and print $prod+$_ . ' ' for 0..$b-1;
    }
    print "\n\n";
}
